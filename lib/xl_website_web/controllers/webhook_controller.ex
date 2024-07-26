defmodule XlWebsiteWeb.WebhookController do
  use XlWebsiteWeb, :controller
  require Logger

  def push(conn, params) do
    with {:ok, _} <- check_valid_secret(conn) |> IO.inspect(label: "Result") do
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
    # ["sha256=5069e2a4ac166fe5ab5bb4934488cacd1dbba54ef15f6fa530dd70e76ce62bea"]
    signature =
      Plug.Conn.get_req_header(conn, "x-hub-signature-256")
      |> List.first()

    signature =
      case String.split(signature, "=") do
        ["sha256", signature] -> signature
        _ -> "invalid_signature"
      end

    {:ok, payload, _} =
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

#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]Conn: %Plug.Conn{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  adapter: {Plug.Cowboy.Conn, :...},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  assigns: %{},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  body_params: %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "after" => "07b55e0a4188b7dfd65161086948986da1475fe4",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "base_ref" => nil,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "before" => "b27e4e69243a1a5754160ed1c27a1f821a83099c",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "commits" => [
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "added" => [],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "author" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]          "email" => "106626890+coenbakker@users.noreply.github.com",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]          "name" => "Coen Bakker",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]          "username" => "coenbakker"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "committer" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]          "email" => "106626890+coenbakker@users.noreply.github.com",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]          "name" => "Coen Bakker",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]          "username" => "coenbakker"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "distinct" => true,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "id" => "07b55e0a4188b7dfd65161086948986da1475fe4",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "message" => "Update README.md",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "modified" => ["solution/README.md"],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "removed" => [],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "timestamp" => "2024-07-26T17:33:27+02:00",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "tree_id" => "2ce7ebbd60b5bb6448683304b9e871c463b3f170",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "url" => "https://github.com/elixirland/xle-book-club/commit/07b55e0a4188b7dfd65161086948986da1475fe4"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      }
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    ],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "compare" => "https://github.com/elixirland/xle-book-club/compare/b27e4e69243a...07b55e0a4188",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "created" => false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "deleted" => false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "forced" => false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "head_commit" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "added" => [],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "author" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "email" => "106626890+coenbakker@users.noreply.github.com",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "name" => "Coen Bakker",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "username" => "coenbakker"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "committer" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "email" => "106626890+coenbakker@users.noreply.github.com",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "name" => "Coen Bakker",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "username" => "coenbakker"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "distinct" => true,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "id" => "07b55e0a4188b7dfd65161086948986da1475fe4",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "message" => "Update README.md",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "modified" => ["solution/README.md"],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "removed" => [],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "timestamp" => "2024-07-26T17:33:27+02:00",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "tree_id" => "2ce7ebbd60b5bb6448683304b9e871c463b3f170",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "url" => "https://github.com/elixirland/xle-book-club/commit/07b55e0a4188b7dfd65161086948986da1475fe4"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "pusher" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "email" => "106626890+coenbakker@users.noreply.github.com",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "name" => "coenbakker"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "ref" => "refs/heads/main",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "repository" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "labels_url" => "https://api.github.com/repos/elixirland/xle-book-club/labels{/name}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "keys_url" => "https://api.github.com/repos/elixirland/xle-book-club/keys{/key_id}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "fork" => false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "owner" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "avatar_url" => "https://avatars.githubusercontent.com/u/175476483?v=4",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "email" => "elixirlandofficial@gmail.com",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "events_url" => "https://api.github.com/users/elixirland/events{/privacy}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "followers_url" => "https://api.github.com/users/elixirland/followers",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "following_url" => "https://api.github.com/users/elixirland/following{/other_user}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "gists_url" => "https://api.github.com/users/elixirland/gists{/gist_id}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "gravatar_id" => "",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "html_url" => "https://github.com/elixirland",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "id" => 175476483,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "login" => "elixirland",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "name" => "elixirland",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "node_id" => "U_kgDOCnWPAw",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "organizations_url" => "https://api.github.com/users/elixirland/orgs",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "received_events_url" => "https://api.github.com/users/elixirland/received_events",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "repos_url" => "https://api.github.com/users/elixirland/repos",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "site_admin" => false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "starred_url" => "https://api.github.com/users/elixirland/starred{/owner}{/repo}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "subscriptions_url" => "https://api.github.com/users/elixirland/subscriptions",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "type" => "User",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "url" => "https://api.github.com/users/elixirland"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "hooks_url" => "https://api.github.com/repos/elixirland/xle-book-club/hooks",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "id" => 828145138,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "teams_url" => "https://api.github.com/repos/elixirland/xle-book-club/teams",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "full_name" => "elixirland/xle-book-club",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "git_commits_url" => "https://api.github.com/repos/elixirland/xle-book-club/git/commits{/sha}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "default_branch" => "main",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "downloads_url" => "https://api.github.com/repos/elixirland/xle-book-club/downloads",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "stargazers_url" => "https://api.github.com/repos/elixirland/xle-book-club/stargazers",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "blobs_url" => "https://api.github.com/repos/elixirland/xle-book-club/git/blobs{/sha}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "collaborators_url" => "https://api.github.com/repos/elixirland/xle-book-club/collaborators{/collaborator}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "node_id" => "R_kgDOMVx98g",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "watchers_count" => 5,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "notifications_url" => "https://api.github.com/repos/elixirland/xle-book-club/notifications{?since,all,participating}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "compare_url" => "https://api.github.com/repos/elixirland/xle-book-club/compare/{base}...{head}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "trees_url" => "https://api.github.com/repos/elixirland/xle-book-club/git/trees{/sha}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "clone_url" => "https://github.com/elixirland/xle-book-club.git",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "has_downloads" => true,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "subscription_url" => "https://api.github.com/repos/elixirland/xle-book-club/subscription",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "url" => "https://github.com/elixirland/xle-book-club",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "statuses_url" => "https://api.github.com/repos/elixirland/xle-book-club/statuses/{sha}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "milestones_url" => "https://api.github.com/repos/elixirland/xle-book-club/milestones{/number}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "svn_url" => "https://github.com/elixirland/xle-book-club",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "events_url" => "https://api.github.com/repos/elixirland/xle-book-club/events",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "stargazers" => 5,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "updated_at" => "2024-07-26T14:01:18Z",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "created_at" => 1720860743,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "html_url" => "https://github.com/elixirland/xle-book-club",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "archived" => false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "allow_forking" => true,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "pulls_url" => "https://api.github.com/repos/elixirland/xle-book-club/pulls{/number}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "mirror_url" => nil,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      ...
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "sender" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "avatar_url" => "https://avatars.githubusercontent.com/u/106626890?v=4",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "events_url" => "https://api.github.com/users/coenbakker/events{/privacy}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "followers_url" => "https://api.github.com/users/coenbakker/followers",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "following_url" => "https://api.github.com/users/coenbakker/following{/other_user}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "gists_url" => "https://api.github.com/users/coenbakker/gists{/gist_id}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "gravatar_id" => "",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "html_url" => "https://github.com/coenbakker",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "id" => 106626890,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "login" => "coenbakker",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "node_id" => "U_kgDOBlr_Sg",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "organizations_url" => "https://api.github.com/users/coenbakker/orgs",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "received_events_url" => "https://api.github.com/users/coenbakker/received_events",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "repos_url" => "https://api.github.com/users/coenbakker/repos",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "site_admin" => false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "starred_url" => "https://api.github.com/users/coenbakker/starred{/owner}{/repo}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "subscriptions_url" => "https://api.github.com/users/coenbakker/subscriptions",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "type" => "User",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "url" => "https://api.github.com/users/coenbakker"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    }
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  cookies: %{},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  halted: false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  host: "elixirland.dev",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  method: "POST",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  owner: #PID<0.2281.0>,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  params: %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "after" => "07b55e0a4188b7dfd65161086948986da1475fe4",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "base_ref" => nil,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "before" => "b27e4e69243a1a5754160ed1c27a1f821a83099c",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "commits" => [
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "added" => [],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "author" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]          "email" => "106626890+coenbakker@users.noreply.github.com",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]          "name" => "Coen Bakker",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]          "username" => "coenbakker"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "committer" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]          "email" => "106626890+coenbakker@users.noreply.github.com",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]          "name" => "Coen Bakker",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]          "username" => "coenbakker"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "distinct" => true,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "id" => "07b55e0a4188b7dfd65161086948986da1475fe4",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "message" => "Update README.md",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "modified" => ["solution/README.md"],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "removed" => [],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "timestamp" => "2024-07-26T17:33:27+02:00",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "tree_id" => "2ce7ebbd60b5bb6448683304b9e871c463b3f170",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "url" => "https://github.com/elixirland/xle-book-club/commit/07b55e0a4188b7dfd65161086948986da1475fe4"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      }
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    ],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "compare" => "https://github.com/elixirland/xle-book-club/compare/b27e4e69243a...07b55e0a4188",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "created" => false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "deleted" => false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "forced" => false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "head_commit" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "added" => [],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "author" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "email" => "106626890+coenbakker@users.noreply.github.com",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "name" => "Coen Bakker",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "username" => "coenbakker"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "committer" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "email" => "106626890+coenbakker@users.noreply.github.com",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "name" => "Coen Bakker",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "username" => "coenbakker"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "distinct" => true,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "id" => "07b55e0a4188b7dfd65161086948986da1475fe4",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "message" => "Update README.md",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "modified" => ["solution/README.md"],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "removed" => [],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "timestamp" => "2024-07-26T17:33:27+02:00",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "tree_id" => "2ce7ebbd60b5bb6448683304b9e871c463b3f170",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "url" => "https://github.com/elixirland/xle-book-club/commit/07b55e0a4188b7dfd65161086948986da1475fe4"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "pusher" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "email" => "106626890+coenbakker@users.noreply.github.com",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "name" => "coenbakker"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "ref" => "refs/heads/main",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "repository" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "labels_url" => "https://api.github.com/repos/elixirland/xle-book-club/labels{/name}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "keys_url" => "https://api.github.com/repos/elixirland/xle-book-club/keys{/key_id}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "fork" => false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "owner" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "avatar_url" => "https://avatars.githubusercontent.com/u/175476483?v=4",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "email" => "elixirlandofficial@gmail.com",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "events_url" => "https://api.github.com/users/elixirland/events{/privacy}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "followers_url" => "https://api.github.com/users/elixirland/followers",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "following_url" => "https://api.github.com/users/elixirland/following{/other_user}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "gists_url" => "https://api.github.com/users/elixirland/gists{/gist_id}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "gravatar_id" => "",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "html_url" => "https://github.com/elixirland",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "id" => 175476483,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "login" => "elixirland",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "name" => "elixirland",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "node_id" => "U_kgDOCnWPAw",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "organizations_url" => "https://api.github.com/users/elixirland/orgs",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "received_events_url" => "https://api.github.com/users/elixirland/received_events",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "repos_url" => "https://api.github.com/users/elixirland/repos",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "site_admin" => false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "starred_url" => "https://api.github.com/users/elixirland/starred{/owner}{/repo}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "subscriptions_url" => "https://api.github.com/users/elixirland/subscriptions",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "type" => "User",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]        "url" => "https://api.github.com/users/elixirland"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "hooks_url" => "https://api.github.com/repos/elixirland/xle-book-club/hooks",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "id" => 828145138,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "teams_url" => "https://api.github.com/repos/elixirland/xle-book-club/teams",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "full_name" => "elixirland/xle-book-club",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "git_commits_url" => "https://api.github.com/repos/elixirland/xle-book-club/git/commits{/sha}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "default_branch" => "main",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "downloads_url" => "https://api.github.com/repos/elixirland/xle-book-club/downloads",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "stargazers_url" => "https://api.github.com/repos/elixirland/xle-book-club/stargazers",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "blobs_url" => "https://api.github.com/repos/elixirland/xle-book-club/git/blobs{/sha}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "collaborators_url" => "https://api.github.com/repos/elixirland/xle-book-club/collaborators{/collaborator}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "node_id" => "R_kgDOMVx98g",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "watchers_count" => 5,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "notifications_url" => "https://api.github.com/repos/elixirland/xle-book-club/notifications{?since,all,participating}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "compare_url" => "https://api.github.com/repos/elixirland/xle-book-club/compare/{base}...{head}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "trees_url" => "https://api.github.com/repos/elixirland/xle-book-club/git/trees{/sha}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "clone_url" => "https://github.com/elixirland/xle-book-club.git",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "has_downloads" => true,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "subscription_url" => "https://api.github.com/repos/elixirland/xle-book-club/subscription",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "url" => "https://github.com/elixirland/xle-book-club",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "statuses_url" => "https://api.github.com/repos/elixirland/xle-book-club/statuses/{sha}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "milestones_url" => "https://api.github.com/repos/elixirland/xle-book-club/milestones{/number}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "svn_url" => "https://github.com/elixirland/xle-book-club",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "events_url" => "https://api.github.com/repos/elixirland/xle-book-club/events",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "stargazers" => 5,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "updated_at" => "2024-07-26T14:01:18Z",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      ...
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    "sender" => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "avatar_url" => "https://avatars.githubusercontent.com/u/106626890?v=4",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "events_url" => "https://api.github.com/users/coenbakker/events{/privacy}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "followers_url" => "https://api.github.com/users/coenbakker/followers",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "following_url" => "https://api.github.com/users/coenbakker/following{/other_user}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "gists_url" => "https://api.github.com/users/coenbakker/gists{/gist_id}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "gravatar_id" => "",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "html_url" => "https://github.com/coenbakker",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "id" => 106626890,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "login" => "coenbakker",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "node_id" => "U_kgDOBlr_Sg",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "organizations_url" => "https://api.github.com/users/coenbakker/orgs",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "received_events_url" => "https://api.github.com/users/coenbakker/received_events",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "repos_url" => "https://api.github.com/users/coenbakker/repos",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "site_admin" => false,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "starred_url" => "https://api.github.com/users/coenbakker/starred{/owner}{/repo}",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "subscriptions_url" => "https://api.github.com/users/coenbakker/subscriptions",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "type" => "User",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "url" => "https://api.github.com/users/coenbakker"
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    }
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  path_info: ["webhooks", "push"],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  path_params: %{},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  port: 80,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  private: %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    XlWebsiteWeb.Router => [],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    :phoenix_view => %{
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "html" => XlWebsiteWeb.WebhookHTML,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]      "json" => XlWebsiteWeb.WebhookJSON
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    :plug_session_fetch => #Function<1.76384852/1 in Plug.Session.fetch_session/1>,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    :before_send => [#Function<0.54455629/1 in Plug.Telemetry.call/2>],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    :phoenix_endpoint => XlWebsiteWeb.Endpoint,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    :phoenix_action => :push,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    :phoenix_layout => %{"html" => {XlWebsiteWeb.Layouts, :app}},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    :phoenix_controller => XlWebsiteWeb.WebhookController,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    :phoenix_format => "json",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    :phoenix_router => XlWebsiteWeb.Router,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    :phoenix_request_logger => {"request_logger", "request_logger"}
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  },
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  query_params: %{},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  query_string: "",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  remote_ip: {0, 0, 0, 0, 0, 65535, 44048, 36474},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  req_cookies: %{},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  req_headers: [
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"accept", "*/*"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"content-length", "7781"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"content-type", "application/json"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"fly-client-ip", "140.82.115.150"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"fly-forwarded-port", "443"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"fly-forwarded-proto", "https"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"fly-forwarded-ssl", "on"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"fly-region", "iad"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"fly-request-id", "01J3QTTJ0XDFVER4CMYHQEZGJF-iad"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"fly-traceparent",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]     "00-4bbcd813fa50355737895ae47b1c0b13-0c3fc1cfdb08e404-00"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"fly-tracestate", ""},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"host", "elixirland.dev"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"user-agent", "GitHub-Hookshot/d37ee03"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"via", "1.1 fly.io"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"x-forwarded-for", "140.82.115.150, 66.241.124.179"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"x-forwarded-port", "443"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"x-forwarded-proto", "https"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"x-forwarded-ssl", "on"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"x-github-delivery", "73ffd8a4-4b64-11ef-8357-7d64d231ab5d"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"x-github-event", "push"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"x-github-hook-id", "492325657"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"x-github-hook-installation-target-id", "828145138"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"x-github-hook-installation-target-type", "repository"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"x-hub-signature", "sha1=0886586af6d2b118c3eaee23aab32241cbc085d6"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"x-hub-signature-256",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]     "sha256=cef34c6226fe6f8a87e087cb00eb8defc5948d5b1e8cc4da37294230f6df3805"},
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]    {"x-request-start", "t=1722008029214029"}
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  ],
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  request_path: "/webhooks/push",
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  resp_body: nil,
#   2024-07-26T15:33:49Z app[148e276fd56738] ams [info]  resp_cookies: %{},

# "sha256=cef34c6226fe6f8a87e087cb00eb8defc5948d5b1e8cc4da37294230f6df3805"
