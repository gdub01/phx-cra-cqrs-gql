defmodule Bonstack.Chat.Aggregates.Member do
  defstruct [
    uuid: nil,
    user_uuid: nil,
    username: nil,
    role: nil,
  ]

  alias Bonstack.Chat.Aggregates.Member
  alias Bonstack.Chat.Commands.CreateMember
  alias Bonstack.Chat.Events.MemberCreated

  @doc """
  Creates an member
  """
  def execute(%Member{uuid: nil}, %CreateMember{} = create) do
    %MemberCreated{
      uuid: create.uuid,
      user_uuid: create.user_uuid,
      username: create.username,
    }
  end

  # state mutators

  def apply(%Member{} = member, %MemberCreated{} = created) do
    %Member{member |
      uuid: created.uuid,
      user_uuid: created.user_uuid,
      username: created.username,
    }
  end

end
