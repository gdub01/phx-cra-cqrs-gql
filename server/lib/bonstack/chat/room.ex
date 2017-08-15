defmodule Bonstack.Chat.Room do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "chat_rooms" do
    field :slug, :string
    field :title, :string
    field :description, :string
    field :room_created_at, :naive_datetime
    field :created_by_member_uuid, :binary_id

    timestamps()
  end
end
