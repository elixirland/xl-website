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

    test "renders hard-coded challenges", %{conn: conn} do
      conn = get(conn, "/challenges")

      resp = html_response(conn, 200)

      assert resp =~ "Book Club"
      assert resp =~ "Simple Chat Room"
      assert resp =~ "Username Generator"
    end
  end

  describe "GET /challenges/:slug" do
    test "renders book club page", %{conn: conn} do
      conn = get(conn, "/challenges/book-club")

      resp = html_response(conn, 200)

      assert resp =~ "Book Club"
      assert resp =~ "Description"
      assert resp =~ "Example solution"
    end

    test "renders simple-chat-room page", %{conn: conn} do
      conn = get(conn, "/challenges/simple-chat-room")

      resp = html_response(conn, 200)

      assert resp =~ "Simple Chat Room"
      assert resp =~ "Description"
      assert resp =~ "Example solution"
    end

    test "renders username-generator page", %{conn: conn} do
      conn = get(conn, "/challenges/username-generator")

      resp = html_response(conn, 200)

      assert resp =~ "Username Generator"
      assert resp =~ "Description"
      assert resp =~ "Example solution"
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
