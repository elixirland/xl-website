defmodule XlWebsiteWeb.GithubClient do
  require Logger
  alias XlWebsiteWeb.HTTPClient

  def fetch_ecosystem_md(full_name) do
    http_request =
      HTTPClient.build(:get, "https://raw.githubusercontent.com/#{full_name}/main/ECOSYSTEM.md")

    case HTTPClient.request(http_request, XlWebsite.Finch) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        Logger.info("Fetched ECOSYSTEM.md from GitHub for #{full_name}")
        body

      {:ok, %Finch.Response{status: status}} ->
        Logger.error("Failed to fetch ECOSYSTEM.md from GitHub. Status: #{status}")

      {:error, reason} ->
        Logger.error("Failed to fetch ECOSYSTEM.md from GitHub. Reason: #{inspect(reason)}")
    end
  end

  def fetch_readme_md(full_name) do
    http_request =
      HTTPClient.build(:get, "https://raw.githubusercontent.com/#{full_name}/main/README.md")

    case HTTPClient.request(http_request, XlWebsite.Finch) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        Logger.info("Fetched README.md from GitHub for #{full_name}")
        body

      {:ok, %Finch.Response{status: status}} ->
        Logger.error("Failed to fetch README.md from GitHub. Status: #{status}")

      {:error, reason} ->
        Logger.error("Failed to fetch README.md from GitHub. Reason: #{inspect(reason)}")
    end
  end
end
