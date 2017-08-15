defmodule Bonstack.Chat.Projectors.Member do
  use Commanded.Projections.Ecto, name: "Chat.Projectors.Member"

  alias Bonstack.Chat.Member
  alias Bonstack.Chat.Events.MemberCreated
  alias Bonstack.Repo

  project %MemberCreated{} = member do
    Ecto.Multi.insert(multi, :member, %Member{
      uuid: member.uuid,
      user_uuid: member.user_uuid,
      username: member.username,
    })
  end



end
