defmodule Bonstack.Repo.Migrations.CreateBonstack.Chat.Author do
  use Ecto.Migration

  def change do
    create table(:chat_members, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :user_uuid, :uuid
      add :username, :string
      add :role, :string

      timestamps()
    end

    create unique_index(:chat_members, [:user_uuid])
  end
end
