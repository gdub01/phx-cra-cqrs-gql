# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :bonstack,
  ecto_repos: [Bonstack.Repo]

# Configures the endpoint
config :bonstack, BonstackWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "G+XRgzjnaJbxnmGqETk3WMLCvlzQ8iT1L8yrQfUmSLvAix0uO6jIQO5xUWGNVTnq",
  render_errors: [view: BonstackWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Bonstack.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections,
  repo: Bonstack.Repo

config :vex,
  sources: [
    Bonstack.Accounts.Validators,
    Bonstack.Validation.Validators,
    Vex.Validators
  ]

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Bonstack",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: "IOjbrty4eMEBzc5aczQn0FR4Gd8PBIG1cC7tqwB7ThV/uKjS5mrResG1Y0lCzTNJ",
  serializer: Bonstack.Auth.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
