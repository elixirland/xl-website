defmodule XlWebsiteWeb.PageControllerTest do
  use XlWebsiteWeb.ConnCase
  import XlWebsite.Factory

  describe "GET /" do
    test "renders home page", %{conn: conn} do
      conn = get(conn, "/")
      resp = html_response(conn, 200)

      assert resp =~ "unlock the Elixir ecosystem"
      assert resp =~ "Discover exercises"
      assert resp =~ "Explore ecosystem"
    end
  end

  describe "GET /exercises" do
    test "renders exercises page", %{conn: conn} do
      conn = get(conn, "/exercises")
      assert html_response(conn, 200) =~ "Exercises"
    end

    test "lists stored exercises", %{conn: conn} do
      insert!(:exercise, %{
        name: "Book Club",
        slug: "book-club"
      })

      insert!(:exercise, %{
        name: "Simple Chat Room",
        slug: "simple-chat-room"
      })

      conn = get(conn, "/exercises")
      resp = html_response(conn, 200)

      assert resp =~ "Book Club"
      assert resp =~ "Simple Chat Room"
    end
  end

  describe "GET /exercises/:slug" do
    test "renders exercise", %{conn: conn} do
      insert!(:exercise, %{
        name: "Book Club",
        slug: "book-club"
      })

      conn = get(conn, "/exercises/book-club")
      resp = html_response(conn, 200)

      assert resp =~ "Introduction"
      assert resp =~ "Task"
      assert resp =~ "How to get started"
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
