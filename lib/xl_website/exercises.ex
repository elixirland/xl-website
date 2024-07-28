defmodule XlWebsite.Exercises do
  import Ecto.Query, warn: false
  alias XlWebsite.Exercises.Exercise
  alias XlWebsite.Repo

  def get_exercises_info_only() do
    Exercise
    |> select([:full_name, :name, :slug, :html_url, :topics, :description])
    |> order_by(asc: :inserted_at)
    |> Repo.all()
  end

  def upsert_exercise(attrs) do
    exercise = get_exercise_by_full_name(attrs[:full_name])

    case exercise do
      nil -> insert_exercise(attrs)
      _ -> update_exercise(exercise, attrs)
    end
  end

  def get_exercise_by_full_name(full_name) do
    Exercise
    |> where([e], e.full_name == ^full_name)
    |> Repo.one()
  end

  defp insert_exercise(attrs) do
    %Exercise{}
    |> Exercise.changeset(attrs)
    |> Repo.insert()
  end

  defp update_exercise(exercise, attrs) do
    exercise
    |> Exercise.changeset(attrs)
    |> Repo.update()
  end

  def get_exercises() do
    Exercise
    |> order_by(asc: :inserted_at)
    |> Repo.all()
  end
end
