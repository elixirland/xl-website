defmodule XlWebsite.Ecosystem do
  import Ecto.Query, warn: false
  alias XlWebsite.Repo
  alias XlWebsite.Ecosystem

  def get_ecosystem_overview() do
    Ecosystem.Category
    |> preload(:tools)
    |> Repo.all()
  end

  @doc """
  Inserts or replaces the ecosystem in the database.

  All existing categories and tools are deleted and replaced with the new ones.
  """

  def insert_or_replace_ecosystem(attrs_of_tools) do
    Repo.transaction(fn ->
      Repo.delete_all(Ecosystem.Tool)
      Repo.delete_all(Ecosystem.Category)

      for cat <- attrs_of_tools do
        struct!(Ecosystem.Category, cat)
        |> Repo.insert!()
      end
    end)
  end
end
