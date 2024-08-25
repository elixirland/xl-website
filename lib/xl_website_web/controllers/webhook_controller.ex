defmodule XlWebsiteWeb.WebhookController do
  use XlWebsiteWeb, :controller
  alias XlWebsite.MarkdownParser
  alias XlWebsiteWeb.GithubClient
  alias XlWebsite.ParamParser
  alias XlWebsite.Projects
  alias XlWebsite.Ecosystem

  action_fallback XlWebsiteWeb.WebhookErrorHandler

  def callback(conn, _params) do
    with {:ok, signature} <- get_signature(conn),
         {:ok, secret} <- get_hashed_secret(signature),
         {:ok, _} <- check_valid_secret(conn.private[:raw_body], secret) do
      conn.body_params
      |> build_project_attrs()
      |> Projects.upsert_project()

      resp(conn, 200, "ok")
    end
  end

  def ecosystem(conn, _params) do
    with {:ok, signature} <- get_signature(conn),
         {:ok, secret} <- get_hashed_secret(signature),
         {:ok, _} <- check_valid_secret(conn.private[:raw_body], secret) do
      conn.body_params
      |> build_list_of_ecosystem_tool_attrs()
      |> Ecosystem.insert_or_replace_ecosystem()

      resp(conn, 200, "ok")
    end
  end

  # Private functions

  @spec build_list_of_ecosystem_tool_attrs(body_params :: map()) :: list()

  defp build_list_of_ecosystem_tool_attrs(body_params) do
    body_params["repository"]["full_name"]
    |> GithubClient.fetch_ecosystem_md()
    |> MarkdownParser.parse_ecosystem_tools()
  end

  @spec build_project_attrs(body_params :: map()) :: map()

  defp build_project_attrs(body_params) do
    full_name = body_params["repository"]["full_name"]
    raw_topics = body_params["repository"]["topics"]

    %{
      full_name: full_name,
      name: ParamParser.build_name(full_name),
      slug: ParamParser.build_slug(full_name),
      html_url: body_params["repository"]["html_url"],
      description: body_params["repository"]["description"],
      topics: ParamParser.parse_topics(raw_topics),
      readme: GithubClient.fetch_readme_md(full_name)
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
end
