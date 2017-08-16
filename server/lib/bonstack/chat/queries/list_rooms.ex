defmodule Bonstack.Chat.Queries.ListRooms do
  import Ecto.Query

  alias Bonstack.Chat.Room

  defmodule Options do
    defstruct [
      limit: 20,
      offset: 0,
    ]

    use ExConstructor
  end

  def paginate(params, repo) do
    options = Options.new(params)
    query = query(options)

    rooms = query |> entries(options) |> repo.all()
    # total_count = query |> count() |> repo.aggregate(:count, :uuid)
    rooms
    # {rooms, total_count}
  end

  defp query(options) do
    from(r in Room)
  end

  defp entries(query, %Options{limit: limit, offset: offset}) do
    query
    |> order_by([r], desc: r.inserted_at)
    |> limit(^limit)
    |> offset(^offset)
  end

  defp count(query) do
    query |> select([:uuid])
  end
end
