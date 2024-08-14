defmodule XlWebsiteWeb.MetaData do
  use Phoenix.Component

  attr :page_title, :string

  def tags(assigns) do
    ~H"""
    <.meta_data page_title={@page_title} />
    """
  end

  defp meta_data(assigns) when assigns.page_title == "Home" do
    ~H"""
    <meta
      name="description"
      content="Exercises with idiomatic example solutions for the Elixir ecosystem."
    />
    <meta property="og:title" content="Elixirland" />
    <meta property="og:url" content="https://elixirland.dev" />
    <meta
      property="og:description"
      content="Exercises with idiomatic example solutions for the Elixir ecosystem."
    />
    """
  end

  defp meta_data(assigns) when assigns.page_title == "Exercises" do
    ~H"""
    <meta name="description" content="Explore our Elixir exercises." />
    <link rel="canonical" content="https://elixirland.dev/exercises" />
    <meta property="og:title" content="Elixirland Exercises" />
    <meta property="og:url" content="https://elixirland.dev/exercises" />
    <meta property="og:description" content="Elixir exercises with idiomatix example solutions." />
    """
  end

  defp meta_data(assigns) when assigns.page_title == "Exercise" do
    ~H"""
    <meta name="description" content="Exercise details." />
    <meta property="og:title" content="Exercise details" />
    <meta property="og:url" content="" />
    <meta property="og:description" content="Exercise details." />
    """
  end

  defp meta_data(assigns) when assigns.page_tiatle == "Ecosystem" do
    ~H"""
    <meta name="description" content="An overview of the Elixirland ecosystem." />
    <meta property="og:title" content="The Elixirland ecosystem" />
    <meta property="og:url" content="https://elixirland.dev/ecosystem" />
    <meta property="og:description" content="An overview of the Elixirland ecosystem." />
    """
  end

  defp meta_data(assigns) when assigns.page_title == "About" do
    ~H"""
    <meta name="description" content="Learn more about Elixirland." />
    <meta property="og:title" content="About Elixirland" />
    <meta property="og:url" content="https://elixirland.dev/about" />
    <meta property="og:description" content="Elixir exercises with idiomatix example solutions." />
    """
  end

  defp meta_data(assigns) when assigns.page_title == "Reviewing" do
    ~H"""
    <meta name="description" content="How does reviewing work at Elixirland?" />
    <meta property="og:title" content="Elixirland reviewing process" />
    <meta property="og:url" content="https://elixirland.dev/reviewing" />
    <meta property="og:description" content="How does reviewing work at Elixirland?" />
    """
  end

  defp meta_data(assigns), do: ~H""
end
