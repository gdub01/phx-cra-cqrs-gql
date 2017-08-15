defmodule Bonstack.Chat.RoomTest do
  use Bonstack.AggregateCase, aggregate: Bonstack.Chat.Aggregates.Room

  alias Bonstack.Chat.Events.RoomCreated

  describe "create room" do
    @tag :unit
    test "should succeed when valid" do
      room_uuid = UUID.uuid4()
      member_uuid = UUID.uuid4()

      assert_events build(:create_room, uuid: room_uuid, member_uuid: member_uuid), [
        %RoomCreated{
          uuid: room_uuid,
          slug: "elixir-chat",
          title: "Talk about elixir",
          description: "good chat",
          member_uuid: member_uuid,
        },
      ]
    end
  end

end
