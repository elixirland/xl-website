defmodule XlWebsite.Ecosystem do
  import Ecto.Query, warn: false
  alias XlWebsite.Repo
  alias XlWebsite.Ecosystem

  def get_ecosystem_overview() do
    Repo.all(from c in Ecosystem.Category, preload: [:tools])
  end

  def upsert_ecosystem(attrs_of_tools) do
    IO.inspect(attrs_of_tools, label: "attrs_of_tools")
  end
end
