defmodule Bonstack.Chat.Commands.DeleteMessage do
  defstruct [
    message_uuid: "",
    deleted_by_member_uuid: "",
  ]

  use ExConstructor
  use Vex.Struct

  alias Bonstack.Chat.{Member,Message}
  alias Bonstack.Chat.Commands.DeleteMessage

  validates :message_uuid, uuid: true
  validates :deleted_by_member_uuid, uuid: true

  def assign_message(%DeleteMessage{} = delete, %Message{uuid: message_uuid}) do
    %DeleteMessage{delete |
      message_uuid: message_uuid,
    }
  end

  def deleted_by(%DeleteMessage{} = delete, %Member{uuid: member_uuid}) do
    %DeleteMessage{delete |
      deleted_by_member_uuid: member_uuid,
    }
  end

end
