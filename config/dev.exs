use Mix.Config

defmodule DevDB do
  def database_host() do
    if System.get_env("DOCKER") do
      "db"
    else
      "localhost"
    end
  end

  def database_name() do
    if System.get_env("DOCKER") do
      "postgres"
    else
      "open_pantry_dev"
    end
  end
end



# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :open_pantry, OpenPantry.Web.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../assets", __DIR__)]]


# Watch static and templates for browser reloading.
config :open_pantry, OpenPantry.Web.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/open_pantry/web/views/.*(ex)$},
      ~r{lib/open_pantry/web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :open_pantry, OpenPantry.Repo,
  adapter: Ecto.Adapters.Postgres,
  types: OpenPantry.PostgresTypes,
  username: "postgres",
  password: "postgres",
  database: DevDB.database_name(),
  hostname: DevDB.database_host(),
  pool_size: 10
