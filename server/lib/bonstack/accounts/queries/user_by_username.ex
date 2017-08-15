defmodule Bonstack.Accounts.Queries.UserByUsername do
  import Ecto.Query

  alias Bonstack.Accounts.User

  def new(username) do
    from u in User,
    where: u.username == ^username
  end
end
