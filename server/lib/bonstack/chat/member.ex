defmodule Bonstack.Chat.Member do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "chat_members" do
    field :user_uuid, :binary_id
    field :username, :string
    field :role, :string

    timestamps()
  end
end
