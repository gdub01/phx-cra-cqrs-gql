defmodule Bonstack.Chat.MessageTest do
  use Bonstack.AggregateCase, aggregate: Bonstack.Chat.Aggregates.Message

  alias Bonstack.Chat.Commands.{
    DeleteMessage,
  }

  alias Bonstack.Chat.Events.{
    MessagePostedInRoom,
    MessageDeleted,
  }

  describe "message on room" do
    @tag :unit
    test "should succeed when valid" do
      message_uuid = UUID.uuid4()
      room_uuid = UUID.uuid4()
      member_uuid = UUID.uuid4()

      assert_events build(:post_message_in_room, uuid: message_uuid, room_uuid: room_uuid, member_uuid: member_uuid), [
        %MessagePostedInRoom{
          uuid: message_uuid,
          body: "elixir stuff...",
          room_uuid: room_uuid,
          member_uuid: member_uuid,
        },
      ]
    end
  end

  describe "delete message" do
    @tag :unit
    test "should succeed when deleted by message member" do
      message_uuid = UUID.uuid4()
      room_uuid = UUID.uuid4()
      user_uuid = UUID.uuid4()

      assert_events [
        build(:post_message_in_room, uuid: message_uuid, room_uuid: room_uuid, member_uuid: user_uuid),
        %DeleteMessage{message_uuid: message_uuid, deleted_by_member_uuid: user_uuid},
      ], [
        %MessageDeleted{
          message_uuid: message_uuid,
          room_uuid: room_uuid,
          member_uuid: user_uuid,
        },
      ]
    end

    @tag :unit
    test "should fail when delete attempted by another user" do
      message_uuid = UUID.uuid4()
      room_uuid = UUID.uuid4()
      member_uuid = UUID.uuid4()
      deleted_by_member_uuid = UUID.uuid4()

      assert_error [
        build(:post_message_in_room, uuid: message_uuid, room_uuid: room_uuid, member_uuid: member_uuid),
        %DeleteMessage{message_uuid: message_uuid, deleted_by_member_uuid: deleted_by_member_uuid},
      ], {:error, :only_message_poster_can_delete}
    end
  end
end
