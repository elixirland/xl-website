defmodule XlWebsiteWeb.WebhookController do
  use XlWebsiteWeb, :controller
  require Logger
  alias XlWebsiteWeb.HTTPClient
  alias XlWebsite.FileSystem

  @exercises_path "#{:code.priv_dir(:xl_website)}/exercises/"
  @repo_prefix "xle-"

  def push(conn, _params) do
    # with {:ok, signature} <- get_signature(conn),
    #      {:ok, secret} <- get_hashed_secret(signature),
    #      {:ok, _} <- check_valid_secret(conn.body_params, secret) do
      conn.body_params
      |> write_topics_to_file()
      |> write_README_to_file()

      resp(conn, 200, "ok")
    # else
    #   {:error, :missing_signature} ->
    #     Logger.warning("missing GitHub webhook secret in request body")

    #     conn
    #     |> put_status(:bad_request)
    #     |> json(%{message: "missing signature"})

    #   {:error, :invalid_signature} ->
    #     Logger.warning("invalid GitHub webhook signature in request body")

    #     conn
    #     |> put_status(:bad_request)
    #     |> json(%{message: "invalid signature"})

    #   {:error, :invalid_secret} ->
    #     Logger.warning("invalid GitHub webhook secret in request body")

    #     conn
    #     |> put_status(:bad_request)
    #     |> json(%{message: "invalid secret"})
    # end
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
      encode_as_JSON_with_sorted_keys(payload)
    )
    |> Base.encode16(case: :lower)
    |> Plug.Crypto.secure_compare(secret)
    |> case do
      true -> {:ok, :valid}
      false -> {:error, :invalid_secret}
    end
  end

  # TODO: Prevent repetition of this function in the controller and the test.
  # Also, is the sorting guaranteed to be the same as in the test?
  defp encode_as_JSON_with_sorted_keys(%{} = map) do
    map
    |> Map.to_list()
    |> Enum.sort_by(&elem(&1, 0))
    |> Jason.OrderedObject.new()
    |> Jason.encode!()
  end

  defp write_topics_to_file(body_params) do
    topics = get_in(body_params, ["repository", "topics"])
    full_name = get_in(body_params, ["repository", "full_name"])
    repo_name = String.split(full_name, "/") |> List.last()
    repo_slug = String.replace(repo_name, @repo_prefix, "")

    exercise_path = @exercises_path <> repo_slug <> "/"

    if not FileSystem.exists?(exercise_path) do
      FileSystem.mkdir_p!(exercise_path)
    end

    FileSystem.write!(exercise_path <> "topics.json", Jason.encode!(topics))

    body_params
  end

  defp write_README_to_file(body_params) do
    full_name = get_in(body_params, ["repository", "full_name"])
    repo_name = String.split(full_name, "/") |> List.last()
    repo_slug = String.replace(repo_name, @repo_prefix, "")

    exercise_path = @exercises_path <> repo_slug <> "/"

    if not FileSystem.exists?(exercise_path) do
      FileSystem.mkdir_p!(exercise_path)
    end

    readme = fetch_readme(full_name)
    FileSystem.write!(exercise_path <> "README.md", readme)

    body_params
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
