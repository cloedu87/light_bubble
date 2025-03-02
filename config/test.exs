import Config
config :light_bubble, token_signing_secret: "yQMKIVrCXuucf6SNpKIvybNO7knYHHAF"
config :ash, disable_async?: true

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :light_bubble, LightBubble.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "light_bubble_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :light_bubble, LightBubbleWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "AUWvKN5PrFHZzwvUL5jTKxX/CcygOTbbpB9ZBt0u+9zNYUXb3EGO3Tqf9KQ6Uq+b",
  server: false

# In test we don't send emails
config :light_bubble, LightBubble.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
