defmodule BonstackWeb.AccountResolver do
  alias Bonstack.{Accounts,Auth}
  alias Bonstack.Accounts.User
  alias BonstackWeb.JWT

  @doc """
  args: %{username: username, email: email, password: password}
  """
  def create(%{input: create_user_params}, _info) do
    with {:ok, %User{} = user} <- Accounts.register_user(create_user_params),
         {:ok, token}          <- JWT.generate_jwt(user)
    do
      {:ok, %{token: token, user: user}}
    end
  end

  @doc """
  args: %{email: email, password: password}
  """
  def login(%{input: %{email: email, password: password}}, _info) do
    with {:ok, %User{} = user} <- Auth.authenticate(email, password),
         {:ok, token}          <- JWT.generate_jwt(user)
    do
      {:ok, %{session: %{token: token}, user: user}}
    else
      {:error, :unauthenticated} -> {:error, message: "email or password is invalid"}
    end
  end

end
