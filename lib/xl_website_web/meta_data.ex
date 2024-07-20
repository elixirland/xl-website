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
    """
  end

  defp taggers(assigns) when assigns.page_title == "Challenges" do
    ~H"""
    <meta
      name="description"
      content="Explore our Elixir challenges."
    >
    """
  end

  defp taggers(assigns) when assigns.page_title == "About" do
    ~H"""
    <meta
      name="description"
      content="Learn more about Elixirland."
    >
    """
  end
end
