defmodule XlWebsiteWeb.MetadataTest do
  alias Ecto.Schema.Metadata
  use XlWebsiteWeb.ConnCase
  alias XlWebsiteWeb.Metadata

  test "tags/1 renders meta tags" do
    html_string =
      Metadata.tags(%{route: "Home", slug: nil, name: nil})
      |> Phoenix.HTML.Safe.to_iodata()
      |> to_string()

    assert html_string =~ "<meta name=\"description\""
    assert html_string =~ "<meta property=\"og:title\""
    assert html_string =~ "<meta property=\"og:url\""
    assert html_string =~ "<meta property=\"og:description\""
  end

  test "tags/1 renders empty string for unknown route" do
    html_string =
      Metadata.tags(%{route: "Unknown", slug: nil, name: nil})
      |> Phoenix.HTML.Safe.to_iodata()
      |> to_string()

    assert html_string == ""
  end
end
