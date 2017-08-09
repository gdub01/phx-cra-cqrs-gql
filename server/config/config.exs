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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
