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

    test "renders metadata tags", %{conn: conn} do
      conn = get(conn, "/")
      resp = html_response(conn, 200)

      assert_metadata(resp)
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

    test "renders metadata tags", %{conn: conn} do
      conn = get(conn, "/")
      resp = html_response(conn, 200)

      assert_metadata(resp)
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
      assert resp =~ "Task description"
      assert resp =~ "How to get started"
      assert resp =~ "Example solution"
    end

    test "renders metadata tags", %{conn: conn} do
      conn = get(conn, "/")
      resp = html_response(conn, 200)

      assert_metadata(resp)
    end
  end

  describe "GET /about" do
    test "renders about page", %{conn: conn} do
      conn = get(conn, "/about")
      assert html_response(conn, 200) =~ "About"
    end

    test "renders metadata tags", %{conn: conn} do
      conn = get(conn, "/")
      resp = html_response(conn, 200)

      assert_metadata(resp)
    end
  end

  describe "GET /contributions" do
    test "renders contributions page", %{conn: conn} do
      conn = get(conn, "/contributions")
      assert html_response(conn, 200) =~ "How can I contribute?"
    end
  end

  test "Invalid path" do
    conn = get(build_conn(), "/invalid")
    assert html_response(conn, 404) =~ "Not Found"
  end

  defp assert_metadata(resp) do
    assert resp =~ "<meta name=\"description\""
    assert resp =~ "<meta property=\"og:title\""
    assert resp =~ "<meta property=\"og:url\""
    assert resp =~ "<meta property=\"og:description\""
  end
end
