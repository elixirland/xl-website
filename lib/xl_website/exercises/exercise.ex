defmodule XlWebsite.Exercises.Exercise do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:full_name, :name, :slug, :description, :html_url, :readme, :topics]

  schema "exercises" do
    field :full_name, :string
    field :name, :string
    field :slug, :string
    field :description, :string
    field :html_url, :string
    field :readme, :string
    field :topics, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(exercise, attrs) do
    exercise
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
