use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bonstack, BonstackWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :ex_unit,
  capture_log: true

# Configure the event store database
config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "bonstack_eventstore_test",
  hostname: "localhost",
  pool_size: 1

# Configure the read store database
config :bonstack, Bonstack.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "bonstack_readstore_test",
  hostname: "localhost",
  pool_size: 1

config :comeonin, :bcrypt_log_rounds, 4
