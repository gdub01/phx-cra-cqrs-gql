defmodule BonstackWeb.ConnHelpers do
  import Plug.Conn
  import Bonstack.Fixture

  alias Bonstack.{Repo,Wait}

  def authenticated_conn(conn) do
    with {:ok, user} <- fixture(:user)
    do
      authenticated_conn(conn, user)
    end
  end

  def authenticated_conn(conn, user) do
    {:ok, jwt} = BonstackWeb.JWT.generate_jwt(user)

    conn
    |> put_req_header("authorization", "Token " <> jwt)
  end

end
