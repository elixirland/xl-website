defmodule XlWebsiteWeb.WebhookControllerTest do
  use XlWebsiteWeb.ConnCase
  import XlWebsite.Factory
  import Plug.Conn
  import Ecto.Query, only: [from: 2]
  alias XlWebsite.Ecosystem
  alias XlWebsite.Repo
  alias XlWebsite.Exercises.Exercise

  # Sourced from the FinchFake module
  @test_ecosystem_categories ["The Web", "Native Applications"]
  @test_ecosystem_tools ["Phoenix Framework", "Phoenix LiveView", "Scenic", "LiveView Native"]

  describe "POST /webhooks/push" do
    setup %{conn: conn} do
      secret = Application.get_env(:xl_website, :github_webhooks_secret)

      body =
        "{\"repository\":{\"description\":\"Some description.\",\"full_name\":\"elixirland/xle-book-club-API\",\"html_url\":\"https://example.com/webhooks\",\"topics\":[\"topic A\",\"topic B\"]}}"

      %{conn: conn, body: body, secret: secret}
    end

    test "creates a new exercise",
         %{conn: conn, body: body, secret: secret} do
      signature =
        :crypto.mac(:hmac, :sha256, secret, body)
        |> Base.encode16(case: :lower)
        |> then(&"sha256=#{&1}")

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", signature)
        |> post("/webhooks/push", body)

      refute nil ==
               Repo.one(
                 from(e in Exercise,
                   where: e.full_name == "elixirland/xle-book-club-API"
                 )
               )

      assert response(conn, :ok) =~ "ok"
    end

    test "updates an existing exercise",
         %{conn: conn, body: body, secret: secret} do
      insert!(:exercise,
        full_name: "elixirland/xle-book-club-API",
        topics: ["Topic X", "Topic Y"]
      )

      signature =
        :crypto.mac(:hmac, :sha256, secret, body)
        |> Base.encode16(case: :lower)
        |> then(&"sha256=#{&1}")

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", signature)
        |> post("/webhooks/push", body)

      assert %{topics: ["Topic a", "Topic b"]} =
               Repo.one(
                 from(e in Exercise,
                   where: e.full_name == "elixirland/xle-book-club-API"
                 )
               )

      assert response(conn, :ok) =~ "ok"
    end

    test "returns ok when secret is valid",
         %{conn: conn, body: body, secret: secret} do
      signature =
        :crypto.mac(:hmac, :sha256, secret, body)
        |> Base.encode16(case: :lower)
        |> then(&"sha256=#{&1}")

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", signature)
        |> post("/webhooks/push", body)

      assert response(conn, :ok) =~ "ok"
    end

    test "returns bad request when secret is invalid",
         %{conn: conn, body: body} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", "sha256=123456")
        |> post("/webhooks/push", body)

      assert response(conn, :bad_request) =~ "invalid secret"
    end

    test "returns bad request when signature is missing",
         %{conn: conn, body: body} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/webhooks/push", body)

      assert response(conn, :bad_request) =~ "missing signature"
    end

    test "returns bad request when signature has wrong prefix",
         %{conn: conn, body: body, secret: secret} do
      signature =
        :crypto.mac(:hmac, :sha256, secret, body)
        |> Base.encode16(case: :lower)
        |> then(&"some_invalid_prefix=#{&1}")

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", signature)
        |> post("/webhooks/push", body)

      assert response(conn, :bad_request) =~ "invalid signature"
    end
  end

  describe "POST /webhooks/ecosystem" do
    setup %{conn: conn} do
      secret = Application.get_env(:xl_website, :github_webhooks_secret)

      body =
        "{\"repository\":{\"description\":\"Some description.\",\"full_name\":\"elixirland/ecosystem\"}}"

      %{conn: conn, body: body, secret: secret}
    end

    test "inserts ecosystem categories and their tools", %{conn: conn, body: body, secret: secret} do
      signature =
        :crypto.mac(:hmac, :sha256, secret, body)
        |> Base.encode16(case: :lower)
        |> then(&"sha256=#{&1}")

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", signature)
        |> post("/webhooks/ecosystem", body)

      cats_in_db = Repo.all(Ecosystem.Category)
      tools_in_db = Repo.all(Ecosystem.Tool)

      assert contains_all_categories?(cats_in_db)
      assert contains_all_tools?(tools_in_db)
      assert response(conn, :ok) =~ "ok"
    end

    test "replaces all ecosystem categories and their tools", %{
      conn: conn,
      body: body,
      secret: secret
    } do
      category = Repo.insert!(%Ecosystem.Category{name: "Category A"})

      Repo.insert!(%Ecosystem.Tool{
        name: "Tool a",
        description: "Description a",
        category_id: category.id
      })

      signature =
        :crypto.mac(:hmac, :sha256, secret, body)
        |> Base.encode16(case: :lower)
        |> then(&"sha256=#{&1}")

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", signature)
        |> post("/webhooks/ecosystem", body)

      cats_in_db = Repo.all(Ecosystem.Category)
      tools_in_db = Repo.all(Ecosystem.Tool)

      refute Enum.any?(cats_in_db, &(&1.name == "Category A"))
      assert contains_all_categories?(cats_in_db)
      assert contains_all_tools?(tools_in_db)
      assert response(conn, :ok) =~ "ok"
    end

    test "returns ok when secret is valid",
         %{conn: conn, body: body, secret: secret} do
      signature =
        :crypto.mac(:hmac, :sha256, secret, body)
        |> Base.encode16(case: :lower)
        |> then(&"sha256=#{&1}")

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", signature)
        |> post("/webhooks/ecosystem", body)

      assert response(conn, :ok) =~ "ok"
    end

    test "returns bad request when secret is invalid",
         %{conn: conn, body: body} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", "sha256=123456")
        |> post("/webhooks/ecosystem", body)

      assert response(conn, :bad_request) =~ "invalid secret"
    end

    test "returns bad request when signature is missing",
         %{conn: conn, body: body} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/webhooks/ecosystem", body)

      assert response(conn, :bad_request) =~ "missing signature"
    end

    test "returns bad request when signature has wrong prefix",
         %{conn: conn, body: body, secret: secret} do
      signature =
        :crypto.mac(:hmac, :sha256, secret, body)
        |> Base.encode16(case: :lower)
        |> then(&"some_invalid_prefix=#{&1}")

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", signature)
        |> post("/webhooks/ecosystem", body)

      assert response(conn, :bad_request) =~ "invalid signature"
    end
  end

  defp contains_all_categories?(categories) do
    Enum.all?(@test_ecosystem_categories, fn cat ->
      Enum.any?(categories, &(&1.name == cat))
    end)
  end

  defp contains_all_tools?(tools) do
    Enum.all?(@test_ecosystem_tools, fn tool ->
      Enum.any?(tools, &(&1.name == tool))
    end)
  end
end
