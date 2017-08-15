defmodule Bonstack.Chat.Projectors.Room do
  use Commanded.Projections.Ecto, name: "Chat.Projectors.Room"

  alias Bonstack.Chat.{Room,Message,Member}
  alias Bonstack.Chat.Events.{
    RoomCreated,
    MessagePostedInRoom,
    MessageDeleted
  }
  alias Bonstack.Repo

  project %RoomCreated{} = created, %{created_at: created_at} do
    multi
    |> Ecto.Multi.run(:room, fn _changes ->
      room = %Room{
        uuid: created.uuid,
        slug: created.slug,
        title: created.title,
        description: created.description,
        room_created_at: created_at,
        created_by_member_uuid: created.member_uuid
      }

      Repo.insert(room)
    end)
  end

  project %MessagePostedInRoom{} = posted, %{created_at: messaged_at} do
    multi
    |> Ecto.Multi.run(:member, fn _changes -> get_member(posted.member_uuid) end)
    |> Ecto.Multi.run(:message, fn %{member: member} ->
      message = %Message{
        uuid: posted.uuid,
        body: posted.body,
        room_uuid: posted.room_uuid,
        member_uuid: posted.uuid
      }

      Repo.insert(message)
    end)
  end

  project %MessageDeleted{message_uuid: message_uuid} do
    Ecto.Multi.delete_all(multi, :message, message_query(message_uuid))
  end

  defp get_member(uuid) do
    case Repo.get(Member, uuid) do
      nil -> {:error, :member_not_found}
      member -> {:ok, member}
    end
  end

  defp member_query(member_uuid) do
    from(m in Member, where: m.uuid == ^member_uuid)
  end

  defp room_query(room_uuid) do
    from(r in Room, where: r.uuid == ^room_uuid)
  end

  defp message_query(message_uuid) do
    from(m in Message, where: m.uuid == ^message_uuid)
  end


end
