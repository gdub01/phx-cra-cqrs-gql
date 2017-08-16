defmodule BonstackWeb.ChatResolver do
  alias Bonstack.Chat

  @doc """
  Args %{limit: limit, offset: offset}
  """
  def list_rooms(args, _info) do
    {:ok, Chat.list_rooms(args)}
  end

  def list_messages_in_room(%{input: %{room_slug: room_slug}}, _info) do
    case Chat.room_by_slug(room_slug) do
      nil -> {:error, "room does not exist"}
      room -> {:ok, Chat.room_messages(room)}
    end
  end

  @doc """
  args: %{title: title, description: descripiton}
  """
  def create_room(%{input: room}, %{context: %{current_user: current_user}}) do
    with {:ok, room} <-
      current_user
      |> get_member
      |> Chat.create_room(room)
    do
      {:ok, room}
    end
  end

  @doc """
  args: %{user_uuid: user_uuid, username: username, role: role}
  """
  def create_message(%{input: %{room_slug: room_slug, body: body}}, %{context: %{current_user: current_user}}) do
    member = get_member(current_user)
    room = Chat.room_by_slug(room_slug)
    Chat.post_message_in_room(room, member, %{body: body})
  end

  @doc """
  args: %{user_uuid: user_uuid, username: username, role: role}
  """
  def create_member(args, _info) do
    Chat.create_member(args)
  end

  defp get_member(current_user) do
    with nil <- current_user |> Chat.get_member(),
        {:ok, member} <- %{user_uuid: current_user.uuid, username: current_user.username, role: "admin"} |> Chat.create_member
    do
      member
    end
  end

end
