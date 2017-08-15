defmodule Bonstack.Chat.Message do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "chat_messages" do
    field :body, :string
    field :room_uuid, :binary_id
    field :member_uuid, :binary_id
    field :member_username, :string
    field :member_role, :string
    field :messaged_at, :naive_datetime

    timestamps()
  end

end
