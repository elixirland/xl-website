defmodule XlWebsiteWeb.Metadata do
  use Phoenix.Component

  @main_description "Learn the Elixir ecosystem by building projects."
  @domain "https://elixirland.dev"

  attr :route, :string
  attr :slug, :string
  attr :name, :string

  def tags(assigns) do
    ~H"""
    <.metadata route={@route} slug={@slug} name={@name} />
    """
  end

  defp metadata(%{route: "Home"} = assigns) do
    assigns =
      assigns
      |> Map.put(:main_description, @main_description)
      |> Map.put(:domain, @domain)

    ~H"""
    <meta name="description" content={@main_description} />
    <meta property="og:title" content="Elixirland" />
    <meta property="og:url" content={@domain} />
    <meta property="og:description" content={@main_description} />
    """
  end

  defp metadata(%{route: "Projects"} = assigns) do
    assigns =
      assigns
      |> Map.put(:main_description, @main_description)
      |> Map.put(:domain, @domain)

    ~H"""
    <meta name="description" content="Explore our Elixir projects." />
    <meta property="og:title" content="Elixirland Projects" />
    <meta property="og:url" content={"#{@domain}/projects"} />
    <meta property="og:description" content={@main_description} />
    """
  end

  defp metadata(%{route: "Project"} = assigns) do
    assigns = Map.put(assigns, :domain, @domain)

    ~H"""
    <meta name="description" content={"The \"#{@name}\" Project"} />
    <meta property="og:title" content={@name} />
    <meta property="og:url" content={"#{@domain}/projects/#{@slug}"} />
    <meta property="og:description" content={"The \"#{@name}\" Project"} />
    """
  end

  defp metadata(%{route: "Ecosystem"} = assigns) do
    assigns = Map.put(assigns, :domain, @domain)

    ~H"""
    <meta name="description" content="An overview of the Elixirland ecosystem." />
    <meta property="og:title" content="The Elixirland ecosystem" />
    <meta property="og:url" content={"#{@domain}/ecosystem"} />
    <meta property="og:description" content="An overview of the Elixir ecosystem." />
    """
  end

  defp metadata(%{route: "About"} = assigns) do
    assigns = Map.put(assigns, :domain, @domain)

    ~H"""
    <meta name="description" content="About Elixirland." />
    <meta property="og:title" content="About Elixirland" />
    <meta property="og:url" content={"#{@domain}/about"} />
    <meta property="og:description" content="About Elixirland." />
    """
  end

  defp metadata(%{route: "Contributions"} = assigns) do
    assigns = Map.put(assigns, :domain, @domain)

    ~H"""
    <meta name="description" content="How to contribute to Elixirland?" />
    <meta property="og:title" content="Contributing to Elixirland" />
    <meta property="og:url" content={"#{@domain}/contributions"} />
    <meta property="og:description" content="How to contribute to Elixirland?" />
    """
  end

  defp metadata(assigns), do: ~H""
end
