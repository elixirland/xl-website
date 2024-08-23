defmodule XlWebsite.Ecosystem.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias XlWebsite.Ecosystem

  schema "categories" do
    field :name, :string
    has_many :tools, Ecosystem.Tool

    timestamps()
  end

  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
