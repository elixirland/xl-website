defmodule XlWebsiteWeb.PageControllerTest do
  use XlWebsiteWeb.ConnCase

  describe "GET /" do
    test "renders home page", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Elixir exercises with idiomatic example solutions"
    end
  end

  describe "GET /exercises" do
    test "renders exercises page", %{conn: conn} do
      conn = get(conn, "/exercises")
      assert html_response(conn, 200) =~ "Exercises"
    end

    test "renders hard-coded exercises", %{conn: conn} do
      conn = get(conn, "/exercises")

      resp = html_response(conn, 200)

      assert resp =~ "Book Club"
      assert resp =~ "Simple Chat Room"
      assert resp =~ "Username Generator"
    end
  end

  describe "GET /exercises/:slug" do
    test "renders book club page", %{conn: conn} do
      conn = get(conn, "/exercises/book-club")

      resp = html_response(conn, 200)

      assert resp =~ "Book Club"
      assert resp =~ "Introduction"
      assert resp =~ "Task"
      assert resp =~ "How to get started"
      assert resp =~ "Example solution"
    end

    test "renders simple-chat-room page", %{conn: conn} do
      conn = get(conn, "/exercises/simple-chat-room")

      resp = html_response(conn, 200)

      assert resp =~ "Simple Chat Room"
      assert resp =~ "Description"
      assert resp =~ "Example solution"
    end

    test "renders username-generator page", %{conn: conn} do
      conn = get(conn, "/exercises/username-generator")

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

  describe "GET /reviewing" do
    test "renders reviewing page", %{conn: conn} do
      conn = get(conn, "/reviewing")
      assert html_response(conn, 200) =~ "How does reviewing work?"
    end
  end

  test "Invalid path" do
    conn = get(build_conn(), "/invalid")
    assert html_response(conn, 404) =~ "Not Found"
  end
end
