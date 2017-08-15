defmodule Bonstack.ChatTest do
  use Bonstack.DataCase

  alias Bonstack.Chat
  alias Bonstack.Chat.{Room,Message}

  describe "create room" do
    setup [
      :create_member,
    ]

    @tag :integration
    test "should succeed with valid data", %{member: member} do
      assert {:ok, %Room{} = room} = Chat.create_room(member, build(:room))

      assert room.slug == "talk-about-elixir"
      assert room.title == "Talk about elixir"
      assert room.description == "good chat"
    end

    @tag :integration
    test "should generate unique URL slug", %{member: member} do
      assert {:ok, %Room{} = room1} = Chat.create_room(member, build(:room))
      assert room1.slug == "talk-about-elixir"

      assert {:ok, %Room{} = room2} = Chat.create_room(member, build(:room))

      assert room2.slug == "talk-about-elixir-2"
    end
  end

  describe "list rooms" do
    setup [
      :create_member,
      :create_rooms,
    ]

    @tag :integration
    test "should list rooms by created date", %{rooms: [room1, room2]} do
      assert {[room2, room1], 2} == Chat.list_rooms()
    end

    @tag :integration
    test "should limit rooms", %{rooms: [_room1, room2]} do
      assert {[room2], 2} == Chat.list_rooms(%{limit: 1})
    end

    @tag :integration
    test "should paginate rooms", %{rooms: [room1, _room2]} do
      assert {[room1], 2} == Chat.list_rooms(%{offset: 1})
    end

  end

  describe "post message in room" do
    setup [
      :create_member,
      :create_room,
    ]

    @tag :integration
    test "should succeed with valid data", %{room: room, member: member} do
      assert {:ok, %Message{} = message} = Chat.post_message_in_room(room, member, build(:message))

      assert message.body == "elixir stuff..."
    end

    @tag :integration
    test "should fail with invalid data", %{room: room, member: member} do
      assert {:error, :validation_failure, reason} = Chat.post_message_in_room(room, member, build(:message, body: ""))

      assert reason == %{body: ["can't be empty"]}
    end
  end

end
