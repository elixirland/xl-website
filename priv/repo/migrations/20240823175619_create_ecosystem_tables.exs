defmodule XlWebsite.Repo.Migrations.CreateEcosystemTables do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
    end

    create table(:tools) do
      add :name, :string, null: false
      add :description, :text, null: false
      add :category_id, references(:categories, on_delete: :nothing)
    end
  end
end
