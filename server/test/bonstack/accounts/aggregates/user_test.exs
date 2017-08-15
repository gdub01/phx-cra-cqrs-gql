defmodule Bonstack.Accounts.UserTest do
  use Bonstack.AggregateCase, aggregate: Bonstack.Accounts.Aggregates.User

  alias Bonstack.Accounts.Events.UserRegistered

  describe "register user" do
    @tag :unit
    test "should succeed when valid" do
      uuid = UUID.uuid4()

      assert_events build(:register_user, uuid: uuid), [
        %UserRegistered{
          uuid: uuid,
          email: "jake@jake.jake",
          username: "jake",
          hashed_password: "jakejake",
        }
      ]
    end
  end
end
