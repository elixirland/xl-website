defmodule XlWebsite.Repo do
  use Ecto.Repo,
    otp_app: :xl_website,
    adapter: Ecto.Adapters.Postgres
end
