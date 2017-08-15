defmodule Bonstack.Chat.Events.MessagePostedInRoom do
  @derive [Poison.Encoder]
  defstruct [
    :uuid,
    :body,
    :room_uuid,
    :member_uuid,
  ]
end
