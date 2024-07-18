defmodule XlWebsiteWeb.PageController do
  use XlWebsiteWeb, :controller
  alias XlWebsite.Parser

  @home "Home"
  @challenges "Challenges"
  @about "About"

  def home(conn, _params) do
    conn
    |> assign(:page_title, @home)
    |> assign(:page_name, @home)
    |> render(:home)
  end

  def challenges(conn, _params) do
    github_repos =
      get_repos()
      |> Parser.normalize_repos()

    conn
    |> assign(:page_title, @challenges)
    |> assign(:page_name, @challenges)
    |> assign(:repos, github_repos)
    |> render(:challenges)
  end

  def about(conn, _params) do
    conn
    |> assign(:page_title, @about)
    |> assign(:page_name, @about)
    |> render(:about)
  end

  # def get_repos() do
  #   Finch.build(:get, "https://api.github.com/users/elixirland/repos")
  #   |> Finch.request(XlWebsite.Finch)
  #   |> case do
  #     {:ok, %Finch.Response{status: 200, body: body}} ->
  #       Jason.decode!(body)
  #     {:ok, %Finch.Response{status: 403}} ->
  #       {:error, "Forbidden"}
  #     {:ok, %Finch.Response{status: 404}} ->
  #       %{error: "Not found"}
  #     {:error, reason} ->
  #       %{error: reason}
  #   end
  # end

  def get_repos() do
    """
    [
      {
        "id": 828145138,
        "node_id": "R_kgDOMVx98g",
        "name": "xlc-book-club",
        "full_name": "elixirland/xlc-book-club",
        "private": false,
        "owner": {
          "login": "elixirland",
          "id": 175476483,
          "node_id": "U_kgDOCnWPAw",
          "avatar_url": "https://avatars.githubusercontent.com/u/175476483?v=4",
          "gravatar_id": "",
          "url": "https://api.github.com/users/elixirland",
          "html_url": "https://github.com/elixirland",
          "followers_url": "https://api.github.com/users/elixirland/followers",
          "following_url": "https://api.github.com/users/elixirland/following{/other_user}",
          "gists_url": "https://api.github.com/users/elixirland/gists{/gist_id}",
          "starred_url": "https://api.github.com/users/elixirland/starred{/owner}{/repo}",
          "subscriptions_url": "https://api.github.com/users/elixirland/subscriptions",
          "organizations_url": "https://api.github.com/users/elixirland/orgs",
          "repos_url": "https://api.github.com/users/elixirland/repos",
          "events_url": "https://api.github.com/users/elixirland/events{/privacy}",
          "received_events_url": "https://api.github.com/users/elixirland/received_events",
          "type": "User",
          "site_admin": false
        },
        "html_url": "https://github.com/elixirland/xl-phoenix-api",
        "description": "Build a simple Phoenix API for a book club.",
        "fork": false,
        "url": "https://api.github.com/repos/elixirland/xl-phoenix-api",
        "forks_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/forks",
        "keys_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/keys{/key_id}",
        "collaborators_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/collaborators{/collaborator}",
        "teams_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/teams",
        "hooks_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/hooks",
        "issue_events_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/issues/events{/number}",
        "events_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/events",
        "assignees_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/assignees{/user}",
        "branches_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/branches{/branch}",
        "tags_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/tags",
        "blobs_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/git/blobs{/sha}",
        "git_tags_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/git/tags{/sha}",
        "git_refs_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/git/refs{/sha}",
        "trees_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/git/trees{/sha}",
        "statuses_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/statuses/{sha}",
        "languages_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/languages",
        "stargazers_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/stargazers",
        "contributors_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/contributors",
        "subscribers_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/subscribers",
        "subscription_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/subscription",
        "commits_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/commits{/sha}",
        "git_commits_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/git/commits{/sha}",
        "comments_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/comments{/number}",
        "issue_comment_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/issues/comments{/number}",
        "contents_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/contents/{+path}",
        "compare_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/compare/{base}...{head}",
        "merges_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/merges",
        "archive_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/{archive_format}{/ref}",
        "downloads_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/downloads",
        "issues_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/issues{/number}",
        "pulls_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/pulls{/number}",
        "milestones_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/milestones{/number}",
        "notifications_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/notifications{?since,all,participating}",
        "labels_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/labels{/name}",
        "releases_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/releases{/id}",
        "deployments_url": "https://api.github.com/repos/elixirland/xl-phoenix-api/deployments",
        "created_at": "2024-07-13T08:52:23Z",
        "updated_at": "2024-07-17T07:36:40Z",
        "pushed_at": "2024-07-17T07:36:37Z",
        "git_url": "git://github.com/elixirland/xl-phoenix-api.git",
        "ssh_url": "git@github.com:elixirland/xl-phoenix-api.git",
        "clone_url": "https://github.com/elixirland/xl-phoenix-api.git",
        "svn_url": "https://github.com/elixirland/xl-phoenix-api",
        "homepage": null,
        "size": 380,
        "stargazers_count": 0,
        "watchers_count": 0,
        "language": "Elixir",
        "has_issues": true,
        "has_projects": true,
        "has_downloads": true,
        "has_wiki": true,
        "has_pages": false,
        "has_discussions": false,
        "forks_count": 0,
        "mirror_url": null,
        "archived": false,
        "disabled": false,
        "open_issues_count": 0,
        "license": null,
        "allow_forking": true,
        "is_template": false,
        "web_commit_signoff_required": false,
        "topics": [
          "elixir",
          "phoenix",
          "api",
          "postgreSQL",
          "ecto"
        ],
        "visibility": "public",
        "forks": 0,
        "open_issues": 0,
        "watchers": 0,
        "default_branch": "main",
        "permissions": {
          "admin": true,
          "maintain": true,
          "push": true,
          "triage": true,
          "pull": true
        }
      }
    ]
    """
    |> Jason.decode!()
  end
end
