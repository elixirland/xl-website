defmodule XlWebsiteWeb.GithubClientTest do
  @moduledoc """
  Tests for the GithubClient module.

  The test environment is set up to use a fake HTTP client. By default, the
  tests use the FinchFake module, which returns successful responses for all
  requests.

  The error handling tests use the FinchErrorFake module, which returns a 404
  status code for all requests.
  """
  use ExUnit.Case, async: true
  require Logger
  import ExUnit.CaptureLog
  alias XlWebsiteWeb.GithubClient

  describe "fetch_ecosystem_md/1" do
    test "fetches ECOSYSTEM.md from GitHub" do
      ecosystem_md = GithubClient.fetch_ecosystem_md("elixirland/xlp-book-club-API")

      assert ecosystem_md =~ "# The Elixir Ecosystem"
    end
  end

  describe "fetch_readme_md/1" do
    test "fetches README.md from GitHub" do
      readme_md = GithubClient.fetch_readme_md("elixirland/xlp-book-club-API")

      assert readme_md =~ "# Some Project Name"
    end
  end

  describe "error handling" do
    setup do
      initial_http_client = Application.get_env(:xl_website, :http_client)
      Application.put_env(:xl_website, :http_client, FinchErrorFake)
      on_exit(fn -> Application.put_env(:xl_website, :http_client, initial_http_client) end)
    end

    test "logs an error when fetching ECOSYSTEM.md fails" do
      log =
        capture_log(fn ->
          GithubClient.fetch_ecosystem_md("elixirland/xlp-book-club-API")
        end)

      assert log =~ "Failed to fetch ECOSYSTEM.md from GitHub. Status: 404"
    end

    test "logs an error when fetching README.md fails" do
      log =
        capture_log(fn ->
          GithubClient.fetch_readme_md("elixirland/xlp-book-club-API")
        end)

      assert log =~ "Failed to fetch README.md from GitHub. Status: 404"
    end
  end
end
