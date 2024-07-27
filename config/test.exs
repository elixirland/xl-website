import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :xl_website, XlWebsite.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "xl_website_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :xl_website, XlWebsiteWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ocalngiF6EcqB2QOqfwrEThDKvWzEC6t2KNFlMzRRIdGjVU3blZxEE7UOAqj9jQl",
  server: false

# In test we don't send emails.
config :xl_website, XlWebsite.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Use a mock for Finch during test
config :xl_website, :http_client, FinchFake
config :xl_website, :file_system, FileFake

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Import development secrets
import_config "dev.secrets.exs"
