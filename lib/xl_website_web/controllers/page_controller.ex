defmodule XlWebsiteWeb.PageController do
  @moduledoc """
  The controller for the pages of the website.

  The route assign must be set for each page to ensure the correct metadata is
  generated. Also, the route assign is used to style the active link in the
  navigation bar.
  """
  use XlWebsiteWeb, :controller
  alias XlWebsite.{ParamParser, MarkdownParser}
  alias XlWebsite.Exercises
  alias XlWebsite.Ecosystem

  @home "Home"
  @exercises "Exercises"
  @ecosystem "Ecosystem"
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
    sorted_ecosystem_data =
      Ecosystem.get_ecosystem_overview()
      |> Enum.sort_by(& &1.name)
      |> Enum.map(fn cat ->
        sorted_tools = Enum.sort_by(cat.tools, & &1.name)
        Map.put(cat, :tools, sorted_tools)
      end)

    conn
    |> assign(:page_title, @title_prefix <> @ecosystem)
    |> assign(:route, @ecosystem)
    |> assign(:ecosystem_data, sorted_ecosystem_data)
    |> render(:ecosystem)
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
              "Task description",
              "Requirements",
              "Assumptions",
              "How to get started",
              "Example solution"
            ]
          )

        conn
        |> assign(:page_title, @title_prefix <> name)
        |> assign(:route, "Exercise")
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

  def contributions(conn, _params) do
    conn
    |> assign(:page_title, @title_prefix <> "How to contribute to Elixirland?")
    |> assign(:route, "Contribute")
    |> render(:contributions)
  end

  def guidelines(conn, _params) do
    conn
    |> assign(:page_title, @title_prefix <> "The guidelines for sumbitting an exercise")
    |> assign(:route, "Guidelines")
    |> render(:submission_guidelines)
  end
end
