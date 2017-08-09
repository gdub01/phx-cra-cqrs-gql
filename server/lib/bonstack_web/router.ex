defmodule BonstackWeb.Router do
  use BonstackWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BonstackWeb do
    pipe_through :api
  end
end
