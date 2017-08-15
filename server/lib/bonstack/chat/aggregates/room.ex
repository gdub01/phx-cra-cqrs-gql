defmodule Bonstack.Chat.Aggregates.Room do
  defstruct [
    uuid: nil,
    slug: nil,
    title: nil,
    description: nil,
    member_uuid: nil,
  ]

  alias Bonstack.Chat.Aggregates.Room

  alias Bonstack.Chat.Commands.CreateRoom

  alias Bonstack.Chat.Events.RoomCreated

  @doc """
  Create a room
  """
  def execute(%Room{uuid: nil}, %CreateRoom{} = room) do
    %RoomCreated{
      uuid: room.uuid,
      slug: room.slug,
      title: room.title,
      description: room.description,
      member_uuid: room.member_uuid,
    }
  end


  # state mutators

  def apply(%Room{} = room, %RoomCreated{} = created) do
    %Room{room |
      uuid: created.uuid,
      slug: created.slug,
      title: created.title,
      description: created.description,
      member_uuid: created.member_uuid,
    }
  end

end
