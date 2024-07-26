defmodule XlWebsiteWeb.WebhookController do
  use XlWebsiteWeb, :controller
  require Logger

  def push(conn, params) do
    IO.inspect(params, label: "Params")
    with {:ok, secret} <- get_secret(params),
         {:ok, _} <- valid_secret?(secret) do
      handle_push(params)
      resp(conn, 200, "ok")
    else
      {:error, :missing_secret} ->
        Logger.log(:warning, "Missing GitHub webhook secret in request body")

        conn
        |> put_status(:bad_request)
        |> json(%{message: "missing secret"})

      {:error, :invalid_secret} ->
        Logger.log(:warning, "Invalid GitHub webhook secret in request body")

        conn
        |> put_status(:bad_request)
        |> json(%{message: "invalid secret"})
    end
  end

  defp get_secret(%{"secret" => secret}), do: {:ok, secret}
  defp get_secret(_params), do: {:error, :missing_secret}

  defp valid_secret?("secret" = secret), do: {:ok, secret}
  defp valid_secret?(_secret), do: {:error, :invalid_secret}

  defp handle_push(params) do
    IO.inspect(params, label: "Success")
  end
end

# curl --header "Content-Type: application/json" --request POST --data "{\"username\":\"xyz\",\"password\":\"xyz\",\"secret\":\"secret\"}" http://localhost:4000/webhooks/push
