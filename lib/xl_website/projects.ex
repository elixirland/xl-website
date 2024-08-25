defmodule XlWebsite.Projects do
  import Ecto.Query, warn: false
  alias XlWebsite.Projects.Project
  alias XlWebsite.Repo

  def get_projects_info_only() do
    Project
    |> select([:full_name, :name, :slug, :html_url, :topics, :description])
    |> order_by(asc: :inserted_at)
    |> Repo.all()
  end

  def upsert_project(attrs) do
    case get_project_by_full_name(attrs[:full_name]) do
      nil -> insert_project(attrs)
      project -> update_project(project, attrs)
    end
  end

  def get_project_by_full_name(full_name) do
    Project
    |> where([e], e.full_name == ^full_name)
    |> Repo.one()
  end

  defp insert_project(attrs) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  defp update_project(project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  def get_projects() do
    Project
    |> order_by(asc: :inserted_at)
    |> Repo.all()
  end
end
