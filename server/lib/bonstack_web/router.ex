defmodule BonstackWeb.Router do
  use BonstackWeb, :router

  pipeline :graphql do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug BonstackWeb.Plug.Context
  end

  scope "/api" do
    pipe_through :graphql

    forward "/", Absinthe.Plug,
      schema: BonstackWeb.Schema
  end

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: BonstackWeb.Schema

end
