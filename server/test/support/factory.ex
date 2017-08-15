defmodule Bonstack.Factory do
  use ExMachina

  alias Bonstack.Accounts.Commands.RegisterUser
  alias Bonstack.Chat.Commands.{
    PostMessageInRoom,
    CreateRoom,
  }

  def room_factory do
    %{
      slug: "elixir-chat",
      title: "Talk about elixir",
      description: "good chat",
      member_uuid: UUID.uuid4(),
    }
  end

  def member_factory do
    %{
      user_uuid: UUID.uuid4(),
      username: "jake",
      role: "admin",
    }
  end

  def message_factory do
    %{
      body: "elixir stuff...",
      room_uuid: UUID.uuid4(),
      member_uuid: UUID.uuid4(),
    }
  end

  def user_factory do
    %{
      email: "jake@jake.jake",
      username: "jake",
      password: "jakejake",
      hashed_password: "jakejake",
      role: "admin",
    }
  end

  def post_message_in_room_factory do
    struct(PostMessageInRoom, build(:message))
  end

  def create_room_factory do
    struct(CreateRoom, build(:room))
  end

  def register_user_factory do
    struct(RegisterUser, build(:user))
  end
end
