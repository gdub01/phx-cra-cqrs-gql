defmodule Bonstack.Router do
  use Commanded.Commands.Router

  alias Bonstack.Accounts.Aggregates.User
  alias Bonstack.Accounts.Commands.{
    RegisterUser,
    UpdateUser,
  }

  alias Bonstack.Chat.Aggregates.{Room,Message,Member}
  alias Bonstack.Chat.Commands.{
    CreateMember,
    PostMessageInRoom,
    DeleteMessage,
    CreateRoom,
  }

  middleware Bonstack.Validation.Middleware.Validate
  middleware Bonstack.Validation.Middleware.Uniqueness

  dispatch [CreateRoom], to: Room, identity: :uuid

  dispatch [CreateMember], to: Member, identity: :uuid

  dispatch [PostMessageInRoom], to: Message, identity: :uuid

  dispatch [DeleteMessage], to: Message, identity: :message_uuid, lifespan: Message

  dispatch [RegisterUser], to: User, identity: :uuid

  dispatch [UpdateUser], to: User, identity: :user_uuid
end
