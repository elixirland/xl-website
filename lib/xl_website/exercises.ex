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
    IO.inspect(attrs, label: "upsert_exercise")

    case get_exercise_by_full_name(attrs[:full_name]) do
      nil -> insert_exercise(attrs)
      exercise -> update_exercise(exercise, attrs)
    end
  end

  def get_exercise_by_full_name(full_name) do
    Exercise
    |> where([e], e.full_name == ^full_name)
    |> Repo.one()
    |> IO.inspect(label: "get_exercise_by_full_name")
  end

  defp insert_exercise(attrs) do
    %Exercise{}
    |> Exercise.changeset(attrs)
    |> Repo.insert()
    |> IO.inspect(label: "insert_exercise")
  end

  defp update_exercise(exercise, attrs) do
    exercise
    |> Exercise.changeset(attrs)
    |> Repo.update()
    |> IO.inspect(label: "update_exercise")
  end

  def get_exercises() do
    Exercise
    |> order_by(asc: :inserted_at)
    |> Repo.all()
    |> IO.inspect(label: "get_exercises")
  end
end
