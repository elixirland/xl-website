defmodule XlWebsiteWeb.WebhookController do
  use XlWebsiteWeb, :controller
  require Logger

  def push(conn, params) do
    IO.inspect(conn, label: "Conn")
    IO.inspect(params, label: "Params")
    with {:ok, _} <- check_valid_secret(conn) do
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

  defp check_valid_secret(conn) do
    signature =
      Plug.Conn.get_req_header(conn, "x-hub-signature-256")
      |> IO.inspect(label: "Raw header")
      |> List.first()

    signature =
      case String.split(signature, "sha256") do
        ["sha256", signature] -> signature
        _ -> "invalid_signature"
      end

    {:ok, payload} =
      Plug.Conn.read_body(conn)

    expected_signature = :crypto.mac(:sha256, Application.get_env(:xl_website, XlWebsiteWeb.Endpoint)[:github_secret], payload)

    if Plug.Crypto.secure_compare(signature, expected_signature) do
      {:ok, :valid}
    else
      {:error, :invalid_secret}
    end
  end

  defp handle_push(params) do
    IO.inspect(params, label: "Success")
  end
end

# curl --header "Content-Type: application/json" --request POST --data "{\"username\":\"xyz\",\"password\":\"xyz\",\"secret\":\"secret\"}" http://localhost:4000/webhooks/push

# "repository" => "html_url"
# "repository" => "topics"

# %{
#   "after" => "b27e4e69243a1a5754160ed1c27a1f821a83099c",
#   "base_ref" => nil,
#   "before" => "7fa1ddb5990e673fa033b8b631ff5e812b69bf58",
#   "commits" => [
#     %{
#       "added" => [],
#       "author" => %{
#         "email" => "106626890+coenbakker@users.noreply.github.com",
#         "name" => "Coen Bakker",
#         "username" => "coenbakker"
#       },
#       "committer" => %{
#         "email" => "106626890+coenbakker@users.noreply.github.com",
#         "name" => "Coen Bakker",
#         "username" => "coenbakker"
#       },
#       "distinct" => true,
#       "id" => "b27e4e69243a1a5754160ed1c27a1f821a83099c",
#       "message" => "Update README.md",
#       "modified" => ["solution/README.md"],
#       "removed" => [],
#       "timestamp" => "2024-07-26T16:01:09+02:00",
#       "tree_id" => "59bf9ed0ebed1864a34614fffd3d240c24c84832",
#       "url" => "https://github.com/elixirland/xle-book-club/commit/b27e4e69243a1a5754160ed1c27a1f821a83099c"
#     }
#   ],
#   "compare" => "https://github.com/elixirland/xle-book-club/compare/7fa1ddb5990e...b27e4e69243a",
#   "created" => false,
#   "deleted" => false,
#   "forced" => false,
#   "head_commit" => %{
#     "added" => [],
#     "author" => %{
#       "email" => "106626890+coenbakker@users.noreply.github.com",
#       "name" => "Coen Bakker",
#       "username" => "coenbakker"
#     },
#     "committer" => %{
#       "email" => "106626890+coenbakker@users.noreply.github.com",
#       "name" => "Coen Bakker",
#       "username" => "coenbakker"
#     },
#     "distinct" => true,
#     "id" => "b27e4e69243a1a5754160ed1c27a1f821a83099c",
#     "message" => "Update README.md",
#     "modified" => ["solution/README.md"],
#     "removed" => [],
#     "timestamp" => "2024-07-26T16:01:09+02:00",
#     "tree_id" => "59bf9ed0ebed1864a34614fffd3d240c24c84832",
#     "url" => "https://github.com/elixirland/xle-book-club/commit/b27e4e69243a1a5754160ed1c27a1f821a83099c"
#   },
#   "pusher" => %{
#     "email" => "106626890+coenbakker@users.noreply.github.com",
#     "name" => "coenbakker"
#   },
#   "ref" => "refs/heads/main",
#   "repository" => %{
#     "labels_url" => "https://api.github.com/repos/elixirland/xle-book-club/labels{/name}",
#     "keys_url" => "https://api.github.com/repos/elixirland/xle-book-club/keys{/key_id}",
#     "fork" => false,
#     "owner" => %{
#       "avatar_url" => "https://avatars.githubusercontent.com/u/175476483?v=4",
#       "email" => "elixirlandofficial@gmail.com",
#       "events_url" => "https://api.github.com/users/elixirland/events{/privacy}",
#       "followers_url" => "https://api.github.com/users/elixirland/followers",
#       "following_url" => "https://api.github.com/users/elixirland/following{/other_user}",
#       "gists_url" => "https://api.github.com/users/elixirland/gists{/gist_id}",
#       "gravatar_id" => "",
#       "html_url" => "https://github.com/elixirland",
#       "id" => 175476483,
#       "login" => "elixirland",
#       "name" => "elixirland",
#       "node_id" => "U_kgDOCnWPAw",
#       "organizations_url" => "https://api.github.com/users/elixirland/orgs",
#       "received_events_url" => "https://api.github.com/users/elixirland/received_events",
#       "repos_url" => "https://api.github.com/users/elixirland/repos",
#       "site_admin" => false,
#       "starred_url" => "https://api.github.com/users/elixirland/starred{/owner}{/repo}",
#       "subscriptions_url" => "https://api.github.com/users/elixirland/subscriptions",
#       "type" => "User",
#       "url" => "https://api.github.com/users/elixirland"
#     },
#     "hooks_url" => "https://api.github.com/repos/elixirland/xle-book-club/hooks",
#     "id" => 828145138,
#     "teams_url" => "https://api.github.com/repos/elixirland/xle-book-club/teams",
#     "full_name" => "elixirland/xle-book-club",
#     "git_commits_url" => "https://api.github.com/repos/elixirland/xle-book-club/git/commits{/sha}",
#     "default_branch" => "main",
#     "downloads_url" => "https://api.github.com/repos/elixirland/xle-book-club/downloads",
#     "stargazers_url" => "https://api.github.com/repos/elixirland/xle-book-club/stargazers",
#     "blobs_url" => "https://api.github.com/repos/elixirland/xle-book-club/git/blobs{/sha}",
#     "collaborators_url" => "https://api.github.com/repos/elixirland/xle-book-club/collaborators{/collaborator}",
#     "node_id" => "R_kgDOMVx98g",
#     "watchers_count" => 5,
#     "notifications_url" => "https://api.github.com/repos/elixirland/xle-book-club/notifications{?since,all,participating}",
#     "compare_url" => "https://api.github.com/repos/elixirland/xle-book-club/compare/{base}...{head}",
#     "trees_url" => "https://api.github.com/repos/elixirland/xle-book-club/git/trees{/sha}",
#     "clone_url" => "https://github.com/elixirland/xle-book-club.git",
#     "has_downloads" => true,
#     "subscription_url" => "https://api.github.com/repos/elixirland/xle-book-club/subscription",
#     "url" => "https://github.com/elixirland/xle-book-club",
#     "statuses_url" => "https://api.github.com/repos/elixirland/xle-book-club/statuses/{sha}",
#     "milestones_url" => "https://api.github.com/repos/elixirland/xle-book-club/milestones{/number}",
#     "svn_url" => "https://github.com/elixirland/xle-book-club",
#     "events_url" => "https://api.github.com/repos/elixirland/xle-book-club/events",
#     "stargazers" => 5,
#     "updated_at" => "2024-07-26T13:00:49Z",
#     "created_at" => 1720860743,
#     "html_url" => "https://github.com/elixirland/xle-book-club",
#     "archived" => false,
#     "allow_forking" => true,
#     "pulls_url" => "https://api.github.com/repos/elixirland/xle-book-club/pulls{/number}",
#     "mirror_url" => nil,
#     "has_projects" => false,
#     "has_wiki" => false,
#     "topics" => [...],
#     ...
#   },
#   "sender" => %{
#     "avatar_url" => "https://avatars.githubusercontent.com/u/106626890?v=4",
#     "events_url" => "https://api.github.com/users/coenbakker/events{/privacy}",
#     "followers_url" => "https://api.github.com/users/coenbakker/followers",
#     "following_url" => "https://api.github.com/users/coenbakker/following{/other_user}",
#     "gists_url" => "https://api.github.com/users/coenbakker/gists{/gist_id}",
#     "gravatar_id" => "",
#     "html_url" => "https://github.com/coenbakker",
#     "id" => 106626890,
#     "login" => "coenbakker",
#     "node_id" => "U_kgDOBlr_Sg",
#     "organizations_url" => "https://api.github.com/users/coenbakker/orgs",
#     "received_events_url" => "https://api.github.com/users/coenbakker/received_events",
#     "repos_url" => "https://api.github.com/users/coenbakker/repos",
#     "site_admin" => false,
#     "starred_url" => "https://api.github.com/users/coenbakker/starred{/owner}{/repo}",
#     "subscriptions_url" => "https://api.github.com/users/coenbakker/subscriptions",
#     "type" => "User",
#     "url" => "https://api.github.com/users/coenbakker"
#   }
# }
