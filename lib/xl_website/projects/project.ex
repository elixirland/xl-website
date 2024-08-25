defmodule XlWebsite.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:full_name, :name, :slug, :description, :html_url, :readme, :topics]

  schema "projects" do
    field :full_name, :string
    field :name, :string
    field :slug, :string
    field :description, :string
    field :html_url, :string
    field :readme, :string
    field :topics, {:array, :string}

    timestamps()
  end

  def changeset(project, attrs) do
    project
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
