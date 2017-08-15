defmodule Bonstack.Chat.Queries.RoomBySlug do
  import Ecto.Query

  alias Bonstack.Chat.Room

  def new(slug) do
    from r in Room,
    where: r.slug == ^slug
  end
end
