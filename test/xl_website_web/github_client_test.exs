defmodule XlWebsiteWeb.GithubClientTest do
  use ExUnit.Case, async: true
  require Logger
  import ExUnit.CaptureLog
  alias XlWebsiteWeb.GithubClient

  describe "error handling" do
    setup do
      initial_http_client = Application.get_env(:xl_website, :http_client)
      Application.put_env(:xl_website, :http_client, FinchErrorFake)
      on_exit(fn -> Application.put_env(:xl_website, :http_client, initial_http_client) end)
    end

    test "logs an error when fetching ECOSYSTEM.md fails" do
      log =
        capture_log(fn ->
          GithubClient.fetch_ecosystem_md("elixirland/xle-book-club-API")
        end)

      assert log =~ "Failed to fetch ECOSYSTEM.md from GitHub. Status: 404"
    end

    test "logs an error when fetching README.md fails" do
      log =
        capture_log(fn ->
          GithubClient.fetch_readme_md("elixirland/xle-book-club-API")
        end)

      assert log =~ "Failed to fetch README.md from GitHub. Status: 404"
    end
  end
end
