defmodule Bonstack.Repo.Migrations.CreateChatMessage do
  use Ecto.Migration

  def change do
    create table(:chat_messages, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :body, :text
      add :room_uuid, :uuid
      add :member_uuid, :uuid
      add :member_username, :text
      add :member_role, :text
      add :messaged_at, :naive_datetime

      timestamps()
    end

    create index(:chat_messages, [:room_uuid])
    create index(:chat_messages, [:member_uuid])
    create index(:chat_messages, [:messaged_at])
  end
end
