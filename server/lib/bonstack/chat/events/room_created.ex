defmodule Bonstack.Chat.Events.RoomCreated do
  @derive [Poison.Encoder]
  defstruct [
    :uuid,
    :slug,
    :title,
    :description,
    :member_uuid,
  ]
end
