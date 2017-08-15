defmodule Bonstack.Repo.Migrations.CreateBonstack.Chat.Room do
  use Ecto.Migration

  def change do
    create table(:chat_rooms, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :slug, :text
      add :title, :text
      add :description, :text
      add :room_created_at, :naive_datetime
      add :created_by_member_uuid, :uuid

      timestamps()
    end

    create unique_index(:chat_rooms, [:slug])
    create index(:chat_rooms, [:created_by_member_uuid])
    create index(:chat_rooms, [:room_created_at])
  end
end
