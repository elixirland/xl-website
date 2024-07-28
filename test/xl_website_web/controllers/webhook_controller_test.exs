defmodule XlWebsiteWeb.WebhookControllerTest do
  use XlWebsiteWeb.ConnCase
  import Plug.Conn

  describe "POST /webhooks/push" do
    setup %{conn: conn} do
      secret = Application.get_env(:xl_website, :github_webhooks_secret)

      # body = encode_as_JSON_with_sorted_keys(%{
      #     repository: %{
      #       full_name: "elixirland/xle-username-generator",
      #       topics: ["topic A", "topic B"]
      #     }
      #   })

      body = "{\"repository\":{\"full_name\":\"elixirland/xle-username-generator\",\"topics\":[\"topic A\",\"topic B\"]}}"

      %{conn: conn, body: body, secret: secret}
    end

    test "returns ok when secret is valid",
         %{conn: conn, body: body, secret: secret} do
      signature =
        :crypto.mac(
          :hmac,
          :sha256,
          secret,
          body
        )
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

    test "returns bad request when signature is invalid",
         %{conn: conn, body: body, secret: secret} do
      signature =
        :crypto.mac(
          :hmac,
          :sha256,
          secret,
          body
        )
        |> Base.encode16(case: :lower)
        |> then(&"some_invalid_prefix=#{&1}")
        |> String.replace("a", "b")

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", signature)
        |> post("/webhooks/push", body)

      assert response(conn, :bad_request) =~ "invalid signature"
    end
  end
end
