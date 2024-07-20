defmodule XlWebsiteWeb.MetaData do
  use Phoenix.Component

  attr :page_title, :string

  def tags(assigns) do
    ~H"""
    <.meta_data page_title={@page_title}/>
    """
  end

  defp meta_data(assigns) when assigns.page_title == "Home" do
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

  defp meta_data(assigns) when assigns.page_title == "Challenges" do
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

  defp meta_data(assigns) when assigns.page_title == "Challenge" do
    ~H"""
    <meta
      name="description"
      content="Challenge details."
    >
    <meta
      property="og:title"
      content="Challenge details"
    >
    <meta
      property="og:url"
      content=""
    >
    <meta
      property="og:description"
      content="Challenge details."
    >

    """
  end

  defp meta_data(assigns) when assigns.page_title == "About" do
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

  defp meta_data(assigns), do: ~H""
end
