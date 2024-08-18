defmodule XlWebsiteWeb.WebhookController do
  use XlWebsiteWeb, :controller
  require Logger
  alias XlWebsiteWeb.HTTPClient
  alias XlWebsite.ParamParser
  alias XlWebsite.Exercises

  def callback(conn, _params) do
    with {:ok, signature} <- get_signature(conn),
         {:ok, secret} <- get_hashed_secret(signature),
         {:ok, _} <- check_valid_secret(conn.private[:raw_body], secret) do
      conn.body_params
      |> extract_exercise_attrs()
      |> Exercises.upsert_exercise()

      resp(conn, 200, "ok")
    else
      {:error, :missing_signature} ->
        Logger.warning("missing GitHub webhook secret in request body")

        conn
        |> put_status(:bad_request)
        |> json(%{message: "missing signature"})

      {:error, :invalid_signature} ->
        Logger.warning("invalid GitHub webhook signature in request body")

        conn
        |> put_status(:bad_request)
        |> json(%{message: "invalid signature"})

      {:error, :invalid_secret} ->
        Logger.warning("invalid GitHub webhook secret in request body")

        conn
        |> put_status(:bad_request)
        |> json(%{message: "invalid secret"})
    end
  end

  @spec extract_exercise_attrs(body_params :: map()) :: map()
  defp extract_exercise_attrs(body_params) do
    full_name = body_params["repository"]["full_name"]
    raw_topics = body_params["repository"]["topics"]

    %{
      full_name: full_name,
      name: ParamParser.build_name(full_name),
      slug: ParamParser.build_slug(full_name),
      html_url: body_params["repository"]["html_url"],
      description: body_params["repository"]["description"],
      topics: ParamParser.parse_topics(raw_topics),
      readme: fetch_readme(full_name)
    }
  end

  defp get_signature(conn) do
    case Plug.Conn.get_req_header(conn, "x-hub-signature-256") do
      [signature] -> {:ok, signature}
      [] -> {:error, :missing_signature}
    end
  end

  defp get_hashed_secret(signature) do
    case String.split(signature, "=") do
      ["sha256", secret] -> {:ok, secret}
      _ -> {:error, :invalid_signature}
    end
  end

  defp check_valid_secret(payload, secret) do
    :crypto.mac(
      :hmac,
      :sha256,
      Application.get_env(:xl_website, :github_webhooks_secret),
      payload
    )
    |> Base.encode16(case: :lower)
    |> Plug.Crypto.secure_compare(secret)
    |> case do
      true -> {:ok, :valid}
      false -> {:error, :invalid_secret}
    end
  end

  defp fetch_readme(full_name) do
    http_request =
      HTTPClient.build(:get, "https://raw.githubusercontent.com/#{full_name}/main/README.md")

    case HTTPClient.request(http_request, XlWebsite.Finch) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        body

      {:ok, %Finch.Response{status: status}} ->
        raise "Failed to fetch README.md from GitHub. Status: #{status}"

      {:error, reason} ->
        raise "Failed to fetch README.md from GitHub. Reason: #{inspect(reason)}"
    end
  end
end
