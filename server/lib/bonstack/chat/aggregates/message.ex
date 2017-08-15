defmodule Bonstack.Chat.Aggregates.Message do
  @behaviour Commanded.Aggregates.AggregateLifespan

  defstruct [
    uuid: nil,
    body: nil,
    room_uuid: nil,
    member_uuid: nil,
    deleted?: false,
  ]

  alias Bonstack.Chat.Aggregates.Message

  alias Bonstack.Chat.Commands.{
    PostMessageInRoom,
    DeleteMessage,
  }

  alias Bonstack.Chat.Events.{
    MessagePostedInRoom,
    MessageDeleted,
  }

  @doc """
  Posts a message in a room
  """
  def execute(%Message{uuid: nil}, %PostMessageInRoom{} = message) do
    %MessagePostedInRoom{
      uuid: message.uuid,
      body: message.body,
      room_uuid: message.room_uuid,
      member_uuid: message.member_uuid,
    }
  end

  @doc """
  Deletes a message
  """
  def execute(
    %Message{uuid: message_uuid, room_uuid: room_uuid, member_uuid: member_uuid, deleted?: false},
    %DeleteMessage{message_uuid: message_uuid, deleted_by_member_uuid: deleted_by_member_uuid})
  do
    case deleted_by_member_uuid do
      ^member_uuid ->
        %MessageDeleted{
          message_uuid: message_uuid,
          room_uuid: room_uuid,
          member_uuid: member_uuid,
        }

      _ -> {:error, :only_message_poster_can_delete}
    end
  end

  # state mutators

  def apply(%Message{} = message, %MessagePostedInRoom{} = posted_message) do
    %Message{message |
      uuid: posted_message.uuid,
      body: posted_message.body,
      room_uuid: posted_message.room_uuid,
      member_uuid: posted_message.member_uuid,
    }
  end

  def apply(%Message{} = message, %MessageDeleted{}) do
    %Message{message |
      deleted?: true
    }
  end

end
