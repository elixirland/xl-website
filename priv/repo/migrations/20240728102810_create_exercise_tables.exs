defmodule XlWebsite.Repo.Migrations.CreateExerciseTables do
  use Ecto.Migration

  def change do
    create table(:exercises) do
      add :full_name, :string
      add :name, :string
      add :slug, :string
      add :description, :text
      add :html_url, :string
      add :readme, :text
      add :topics, {:array, :string}

      timestamps()
    end
  end
end
