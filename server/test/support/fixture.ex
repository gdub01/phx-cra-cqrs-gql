defmodule Bonstack.Fixture do
  import Bonstack.Factory

  alias Bonstack.{Accounts,Chat}
  alias Bonstack.Chat.Member
  alias Bonstack.{Repo,Wait}

  def register_user(_context) do
    {:ok, user} = fixture(:user)

    [
      user: user,
    ]
  end

  def create_member(%{user: user}) do
    {:ok, member} = fixture(:member, user_uuid: user.uuid)

    [
      member: member,
    ]
  end

  def create_member(_context) do
    {:ok, member} = fixture(:member, user_uuid: UUID.uuid4())

    [
      member: member,
    ]
  end

  def create_room(%{member: member}) do
    {:ok, room} = fixture(:room, member: member)

    [
      room: room,
    ]
  end

  def create_rooms(%{member: member}) do
    {:ok, room1} = fixture(:room, member: member)
    {:ok, room2} = fixture(:room, member: member, title: "Elixir Chat", description: "talk about elixir")

    [
      rooms: [room1, room2],
    ]
  end

  def wait_for_member(%{user: user}) do
    {:ok, member} = Wait.until(fn -> Repo.get_by(Member, user_uuid: user.uuid) end)

    [
      member: member,
    ]
  end

  def post_message_in_room(%{room: room, member: member}) do
    {:ok, message} = fixture(:message, room: room, member: member)

    [
      message: message,
    ]
  end


  def fixture(resource, attrs \\ [])

  def fixture(:member, attrs) do
    build(:member, attrs) |> Chat.create_member()
  end

  def fixture(:user, attrs) do
    build(:user, attrs) |> Accounts.register_user()
  end

  def fixture(:room, attrs) do
    {member, attrs} = Keyword.pop(attrs, :member)

    Chat.create_room(member, build(:room, attrs))
  end

  def fixture(:message, attrs) do
    {room, attrs} = Keyword.pop(attrs, :room)
    {member, attrs} = Keyword.pop(attrs, :member)

    Chat.post_message_in_room(room, member, build(:message, attrs))
  end


end
