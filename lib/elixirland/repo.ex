defmodule Elixirland.Repo do
  use Ecto.Repo,
    otp_app: :elixirland,
    adapter: Ecto.Adapters.Postgres
end
