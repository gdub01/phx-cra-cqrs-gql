defmodule Bonstack.Chat.Commands.PostMessageInRoom do
  defstruct [
    uuid: "",
    body: "",
    room_uuid: "",
    member_uuid: "",
  ]

  use ExConstructor
  use Vex.Struct

  alias Bonstack.Chat.{Member,Message,Room}
  alias Bonstack.Chat.Commands.PostMessageInRoom

  validates :uuid, uuid: true
  validates :body, presence: [message: "can't be empty"], string: true
  validates :room_uuid, uuid: true
  validates :member_uuid, uuid: true

  def assign_uuid(%PostMessageInRoom{} = message, uuid) do
    %PostMessageInRoom{message |
      uuid: uuid,
    }
  end

  def assign_room(%PostMessageInRoom{} = message, %Room{uuid: room_uuid}) do
    %PostMessageInRoom{message |
      room_uuid: room_uuid,
    }
  end

  def assign_member(%PostMessageInRoom{} = message, %Member{uuid: member_uuid}) do
    %PostMessageInRoom{message |
      member_uuid: member_uuid,
    }
  end

end
