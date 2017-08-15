defmodule Bonstack.Chat.Commands.CreateMember do
  defstruct [
    uuid: "",
    user_uuid: "",
    username: "",
    role: "",
  ]

  use ExConstructor
  use Vex.Struct

  alias Bonstack.Chat.Commands.CreateMember

  validates :uuid, uuid: true

  validates :user_uuid, uuid: true

  validates :username,
    presence: [message: "can't be empty"],
    format: [with: ~r/^[a-z0-9]+$/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true

  validates :role,
    presence: [message: "can't be empty"],
    inclusion: ["admin", "core", "participator"],
    string: true

  @doc """
  Assign a unique identity
  """
  def assign_uuid(%CreateMember{} = create_member, uuid) do
    %CreateMember{create_member |
      uuid: uuid
    }
  end
end
