defmodule Bonstack.Chat.Commands.CreateRoom do
  defstruct [
    uuid: "",
    slug: "",
    title: "",
    description: "",
    member_uuid: "",
  ]
  use ExConstructor
  use Vex.Struct

  alias Bonstack.Chat.{Member,Slugger}
  alias Bonstack.Chat.Commands.CreateRoom

  alias Bonstack.Chat.Validators.UniqueRoomSlug

  validates :uuid, uuid: true

  validates :slug,
    presence: [message: "can't be empty"],
    format: [with: ~r/^[a-z0-9\-]+$/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    by: &UniqueRoomSlug.validate/2

  validates :title, presence: [message: "can't be empty"], string: true

  validates :description, presence: [message: "can't be empty"], string: true

  validates :member_uuid, uuid: true

  @doc """
  Assign a unique identity
  """
  def assign_uuid(%CreateRoom{} = create_room, uuid) do
    %CreateRoom{create_room | uuid: uuid}
  end

  @doc """
  Assign the member
  """
  def assign_member(%CreateRoom{} = create_room, %Member{uuid: uuid}) do
    %CreateRoom{create_room | member_uuid: uuid}
  end

  @doc """
  Generate a unique URL slug from the room title
  """
  def generate_url_slug(%CreateRoom{title: title} = create_room) do
    case Slugger.slugify(title) do
      {:ok, slug} -> %CreateRoom{create_room | slug: slug}
      _ -> create_room
    end
  end
end

defimpl Bonstack.Validation.Middleware.Uniqueness.UniqueFields, for: Bonstack.Chat.Commands.CreateRoom do
  def unique(%Bonstack.Chat.Commands.CreateRoom{uuid: uuid}), do: [
    {:slug, "has already been taken", uuid},
  ]
end
