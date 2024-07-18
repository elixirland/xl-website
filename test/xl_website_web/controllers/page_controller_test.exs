defmodule XlWebsiteWeb.PageControllerTest do
  use XlWebsiteWeb.ConnCase

  describe "GET /" do
    test "renders home page", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Elixir challenges with idiomatic example solutions"
    end
  end

  describe "GET /challenges" do
    test "renders challenges page", %{conn: conn} do
      conn = get(conn, "/challenges")
      assert html_response(conn, 200) =~ "Challenges"
    end

    test "renders Book Club challenge", %{conn: conn} do
      conn = get(conn, "/challenges")
      assert html_response(conn, 200) =~ "Book Club"
    end
  end

  describe "GET /about" do
    test "renders about page", %{conn: conn} do
      conn = get(conn, "/about")
      assert html_response(conn, 200) =~ "About"
    end
  end

  test "Invalid path" do
    conn = get(build_conn(), "/invalid")
    assert html_response(conn, 404) =~ "Not Found"
  end
end
