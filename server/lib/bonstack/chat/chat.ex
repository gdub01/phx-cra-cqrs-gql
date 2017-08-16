defmodule Bonstack.Chat do
  @moduledoc """
  Boundary for Chats
  """

  alias Bonstack.Accounts.User
  alias Bonstack.Chat.{Member,Message,Room}
  alias Bonstack.Chat.Commands.{CreateMember,CreateRoom,DeleteMessage,PostMessageInRoom}
  alias Bonstack.Chat.Queries.{RoomBySlug,RoomMessages,ListRooms}
  alias Bonstack.{Repo, Router, Wait}

  @doc """
  Get the member for a given user account, or return `nil` if not found
  """
  def get_member(user)
  def get_member(nil), do: nil
  def get_member(%User{uuid: user_uuid}), do: Repo.get_by(Member, user_uuid: user_uuid)

  @doc """
  Get the member for a given user account, or raise an `Ecto.NoResultsError` if not found
  """
  def get_member!(%User{uuid: user_uuid}), do: Repo.get_by!(Member, user_uuid: user_uuid)

  @doc """
  Get a member by their username, or raise an `Ecto.NoResultsError` if not found
  """
  def member_by_username!(username), do: Repo.get_by!(Member, username: username)


  @doc """
  Returns most recent rooms globally by default.

  Provide tag, member, or favorited query parameter to filter results.
  """
  @spec list_rooms(params :: map()) :: {rooms :: list(Room.t), room_count :: non_neg_integer()}
  def list_rooms(params \\ %{})
  def list_rooms(params) do
    ListRooms.paginate(params, Repo)
  end


  @doc """
  Get a room by its URL slug, or return `nil` if not found
  """
  def room_by_slug(slug), do: room_by_slug_query(slug) |> Repo.one()

  @doc """
  Get a room by its URL slug, or raise an `Ecto.NoResultsError` if not found
  """
  def room_by_slug!(slug), do: room_by_slug_query(slug) |> Repo.one!()

  @doc """
  Get messages from a room
  """
  def room_messages(%Room{uuid: room_uuid}) do
    room_uuid
    |> RoomMessages.new()
    |> Repo.all()
  end

  @doc """
  Get a message by its UUID, or raise an `Ecto.NoResultsError` if not found
  """
  def get_message!(message_uuid), do: Repo.get!(Message, message_uuid)

  @doc """
  Create a member
  """
  def create_member(attrs \\ %{}) do
    uuid = UUID.uuid4()

    attrs
    |> CreateMember.new()
    |> CreateMember.assign_uuid(uuid)
    |> Router.dispatch()
    |> case do
      :ok -> Wait.until(fn -> Repo.get(Member, uuid) end)
      reply -> reply
    end
  end


  @doc """
  Creates a room by the given member.
  """
  def create_room(%Member{} = member, attrs \\ %{}) do
    uuid = UUID.uuid4()

    attrs
    |> CreateRoom.new()
    |> CreateRoom.assign_uuid(uuid)
    |> CreateRoom.assign_member(member)
    |> CreateRoom.generate_url_slug()
    |> Router.dispatch()
    |> case do
      :ok -> Wait.until(fn -> Repo.get(Room, uuid) end)
      reply -> reply
    end
  end


  @doc """
  Add a message to a room
  """
  def post_message_in_room(%Room{} = room, %Member{} = member, attrs \\ %{}) do
    uuid = UUID.uuid4()

    attrs
    |> PostMessageInRoom.new()
    |> PostMessageInRoom.assign_uuid(uuid)
    |> PostMessageInRoom.assign_room(room)
    |> PostMessageInRoom.assign_member(member)
    |> Router.dispatch()
    |> case do
      :ok -> Wait.until(fn -> Repo.get(Message, uuid) end)
      reply -> reply
    end
  end

  @doc """
  Delete a message made by the user. Returns `:ok` on success
  """
  def delete_message(%Message{} = message, %Member{} = member) do
    %DeleteMessage{}
    |> DeleteMessage.assign_message(message)
    |> DeleteMessage.deleted_by(member)
    |> Router.dispatch()
  end

  defp room_by_slug_query(slug) do
    slug
    |> String.downcase()
    |> RoomBySlug.new()
  end

end
