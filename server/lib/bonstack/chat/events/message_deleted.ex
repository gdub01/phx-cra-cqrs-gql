defmodule Bonstack.Chat.Events.MessageDeleted do
  @derive [Poison.Encoder]
  defstruct [
    :message_uuid,
    :room_uuid,
    :member_uuid,
  ]
end
