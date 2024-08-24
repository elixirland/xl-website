defmodule XlWebsite.Ecosystem.Tool do
  use Ecto.Schema
  import Ecto.Changeset
  alias XlWebsite.Ecosystem

  schema "tools" do
    field :name, :string
    field :description, :string
    belongs_to :category, Ecosystem.Category
  end

  def changeset(tool, attrs) do
    tool
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
