defmodule XlWebsiteWeb.WebhookErrorHandler do
  use Phoenix.Controller
  require Logger

  def call(conn, {:error, :missing_signature}) do
    Logger.warning("missing GitHub webhook secret in request body")

    conn
    |> put_status(:bad_request)
    |> json(%{message: "missing signature"})
  end

  def call(conn, {:error, :invalid_signature}) do
    Logger.warning("invalid GitHub webhook signature in request body")

    conn
    |> put_status(:bad_request)
    |> json(%{message: "invalid signature"})
  end

  def call(conn, {:error, :invalid_secret}) do
    Logger.warning("invalid GitHub webhook secret in request body")

    conn
    |> put_status(:bad_request)
    |> json(%{message: "invalid secret"})
  end
end
