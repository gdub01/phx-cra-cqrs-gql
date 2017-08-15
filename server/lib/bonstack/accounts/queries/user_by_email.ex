defmodule Bonstack.Accounts.Queries.UserByEmail do
  import Ecto.Query

  alias Bonstack.Accounts.User

  def new(email) do
    from u in User,
    where: u.email == ^email
  end
end
