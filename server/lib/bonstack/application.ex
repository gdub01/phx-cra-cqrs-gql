defmodule Bonstack.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Bonstack.Repo, []),
      # Start the endpoint when the application starts
      supervisor(BonstackWeb.Endpoint, []),

      # Accounts context
      supervisor(Bonstack.Accounts.Supervisor, []),

      # Enforce unique constraints
      worker(Bonstack.Validation.Unique, []),

      # Read model projections
      worker(Bonstack.Chat.Projectors.Member, [], id: :chat_members_projector),
      worker(Bonstack.Chat.Projectors.Room, [], id: :chat_room_projector),

    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bonstack.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BonstackWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
