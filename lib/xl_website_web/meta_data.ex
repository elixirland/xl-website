defmodule XlWebsiteWeb.MetaData do
  use Phoenix.Component

  attr :page_title, :string

  def tags(assigns) do
    ~H"""
    <.taggers page_title={@page_title}/>
    """
  end

  defp taggers(assigns) when assigns.page_title == "Home" do
    ~H"""
    <meta
      name="description"
      content="Elixir challenges with idiomatix example solutions."
    >
    <meta
      property="og:title"
      content="Elixirland"
    >
    <meta
      property="og:url"
      content="https://elixirland.dev"
    >
    <meta
      property="og:description"
      content="Elixir challenges with idiomatix example solutions."
    >

    """
  end

  defp taggers(assigns) when assigns.page_title == "Challenges" do
    ~H"""
    <meta
      name="description"
      content="Explore our Elixir challenges."
    >
    <link
      rel="canonical"
      content="https://elixirland.dev/challenges"
    />
    <meta
      property="og:title"
      content="Elixirland Challenges"
    >
    <meta
      property="og:url"
      content="https://elixirland.dev/challenges"
    >
    <meta
      property="og:description"
      content="Elixir challenges with idiomatix example solutions."
    >

    """
  end

  defp taggers(assigns) when assigns.page_title == "About" do
    ~H"""
    <meta
      name="description"
      content="Learn more about Elixirland."
    >
    <meta
      property="og:title"
      content="About Elixirland"
    >
    <meta
      property="og:url"
      content="https://elixirland.dev/about"
    >
    <meta
      property="og:description"
      content="Elixir challenges with idiomatix example solutions."
    >

    """
  end
end
