defmodule XlWebsiteWeb.PageController do
  use XlWebsiteWeb, :controller
  alias XlWebsite.{ParamParser, MarkdownParser}
  alias XlWebsite.FileSystem
  alias XlWebsite.Exercises

  @home "Home"
  @exercises "Exercises"
  @about "About"
  @repo_prefix "xle-"
  @title_prefix "Elixirland - "

  def home(conn, _params) do
    conn
    |> assign(:page_title, @title_prefix <> "Elixir exercises with idiomatic example solutions")
    |> assign(:route, @home)
    |> render(:home)
  end

  def ecosystem(conn, _params) do
    ecosystem_data =
      FileSystem.read!(path_to("ecosystem.json"))
      |> Jason.decode!()
      |> Enum.sort_by(&Map.get(&1, "name"))

    conn
    |> assign(:page_title, @title_prefix <> "The Elixir ecosystem")
    |> assign(:route, "Ecosystem")
    |> assign(:ecosystem_data, ecosystem_data)
    |> render(:ecosystem)
  end

  defp path_to(file) do
    Path.join(:code.priv_dir(:xl_website), "/#{file}")
  end

  def exercises(conn, _params) do
    exercise_info = Exercises.get_exercises_info_only()

    conn
    |> assign(:page_title, @title_prefix <> @exercises)
    |> assign(:route, @exercises)
    |> assign(:exercises, exercise_info)
    |> render(:exercises)
  end

  def exercise(conn, %{"slug" => slug}) do
    case Exercises.get_exercise_by_full_name("elixirland/#{@repo_prefix}#{slug}") do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(XlWebsiteWeb.ErrorHTML)
        |> render("404.html")

      exercise ->
        name = ParamParser.slug_to_name(slug)

        readme =
          MarkdownParser.filter_readme_sections(
            exercise.readme,
            [
              "Introduction",
              "Task",
              "Requirements",
              "Assumptions",
              "How to get started",
              "Example solution"
            ]
          )

        conn
        |> assign(:page_title, @title_prefix <> name)
        |> assign(:name, name)
        |> assign(:slug, slug)
        |> assign(:html_url, exercise.html_url)
        |> assign(:repo_prefix, @repo_prefix)
        |> assign(:readme, readme)
        |> assign(:topics, exercise.topics)
        |> render(:exercise)
    end
  end

  def about(conn, _params) do
    conn
    |> assign(:page_title, @title_prefix <> @about)
    |> assign(:route, @about)
    |> render(:about)
  end

  def reviewing(conn, _params) do
    conn
    |> assign(:page_title, @title_prefix <> "How does exercise reviewing work?")
    |> render(:reviewing)
  end
end
