defmodule Bonstack.Chat.Queries.RoomMessages do
  import Ecto.Query

  alias Bonstack.Chat.Message

  def new(room_uuid) do
    from m in Message,
    where: m.room_uuid == ^room_uuid,
    order_by: [desc: m.messaged_at]
  end
end
