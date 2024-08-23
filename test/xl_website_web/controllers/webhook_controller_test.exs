defmodule XlWebsiteWeb.WebhookControllerTest do
  use XlWebsiteWeb.ConnCase
  import XlWebsite.Factory
  import Plug.Conn
  import Ecto.Query, only: [from: 2]
  alias XlWebsite.Repo
  alias XlWebsite.Exercises.Exercise

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
        "{\"repository\":{\"description\":\"Some description.\",\"full_name\":\"elixirland/xle-book-club-API\",\"html_url\":\"https://example.com/webhooks\",\"topics\":[\"topic A\",\"topic B\"]}}"

      %{conn: conn, body: body, secret: secret}
    end

    test "creates an ecosystem tool", %{conn: conn, body: body, secret: secret} do
    end

    test "updates an existing ecosystem tool", %{conn: conn, body: body, secret: secret} do
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
end
