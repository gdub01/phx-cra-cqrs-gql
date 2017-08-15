defmodule Bonstack.Chat.Events.MemberCreated do
  @derive [Poison.Encoder]
  defstruct [
    :uuid,
    :user_uuid,
    :username,
    :role,
  ]
end
