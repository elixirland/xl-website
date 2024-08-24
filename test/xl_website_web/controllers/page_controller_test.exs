defmodule XlWebsiteWeb.PageControllerTest do
  use XlWebsiteWeb.ConnCase
  import XlWebsite.Factory

  describe "GET /" do
    test "renders home page", %{conn: conn} do
      conn = get(conn, "/")
      html = html_response(conn, 200)

      assert html =~ "unlock the Elixir ecosystem"
      assert html =~ "Discover exercises"
      assert html =~ "Explore ecosystem"
    end

    test "renders metadata tags", %{conn: conn} do
      conn = get(conn, "/")
      html = html_response(conn, 200)

      assert_metadata(html)
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
      html = html_response(conn, 200)

      assert html =~ "Book Club"
      assert html =~ "Simple Chat Room"
    end

    test "renders metadata tags", %{conn: conn} do
      conn = get(conn, "/")
      html = html_response(conn, 200)

      assert_metadata(html)
    end
  end

  describe "GET /exercises/:slug" do
    test "renders exercise", %{conn: conn} do
      insert!(:exercise, %{
        name: "Book Club",
        slug: "book-club"
      })

      conn = get(conn, "/exercises/book-club")
      html = html_response(conn, 200)

      assert html =~ "Introduction"
      assert html =~ "Task description"
      assert html =~ "How to get started"
      assert html =~ "Example solution"
    end

    test "renders metadata tags", %{conn: conn} do
      conn = get(conn, "/")
      html = html_response(conn, 200)

      assert_metadata(html)
    end
  end

  describe "GET /about" do
    test "renders about page", %{conn: conn} do
      conn = get(conn, "/about")
      assert html_response(conn, 200) =~ "About"
    end

    test "renders metadata tags", %{conn: conn} do
      conn = get(conn, "/")
      html = html_response(conn, 200)

      assert_metadata(html)
    end
  end

  describe "GET /contributions" do
    test "renders contributions page", %{conn: conn} do
      conn = get(conn, "/contributions")
      assert html_response(conn, 200) =~ "How can I contribute?"
    end
  end

  describe "GET /ecosystem" do
    test "renders ecosystem page", %{conn: conn} do
      category = insert!(:category, name: "The Web")
      insert!(:tool, name: "Some tool", category_id: category.id)

      conn = get(conn, "/ecosystem")
      html = html_response(conn, 200)

      assert html =~ "The Elixir Ecosystem"
      assert html =~ "The Web"
      assert html =~ "Some tool"
    end
  end

  test "Invalid path" do
    conn = get(build_conn(), "/invalid")
    assert html_response(conn, 404) =~ "Not Found"
  end

  defp assert_metadata(html) do
    assert html =~ "<meta name=\"description\""
    assert html =~ "<meta property=\"og:title\""
    assert html =~ "<meta property=\"og:url\""
    assert html =~ "<meta property=\"og:description\""
  end
end
