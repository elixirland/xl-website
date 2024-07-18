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
        "html_url": "https://github.com/elixirland/xlc-book-club",
        "description": "Build a simple Phoenix API for a book club.",
        "fork": false,
        "url": "https://api.github.com/repos/elixirland/xlc-book-club",
        "forks_url": "https://api.github.com/repos/elixirland/xlc-book-club/forks",
        "keys_url": "https://api.github.com/repos/elixirland/xlc-book-club/keys{/key_id}",
        "collaborators_url": "https://api.github.com/repos/elixirland/xlc-book-club/collaborators{/collaborator}",
        "teams_url": "https://api.github.com/repos/elixirland/xlc-book-club/teams",
        "hooks_url": "https://api.github.com/repos/elixirland/xlc-book-club/hooks",
        "issue_events_url": "https://api.github.com/repos/elixirland/xlc-book-club/issues/events{/number}",
        "events_url": "https://api.github.com/repos/elixirland/xlc-book-club/events",
        "assignees_url": "https://api.github.com/repos/elixirland/xlc-book-club/assignees{/user}",
        "branches_url": "https://api.github.com/repos/elixirland/xlc-book-club/branches{/branch}",
        "tags_url": "https://api.github.com/repos/elixirland/xlc-book-club/tags",
        "blobs_url": "https://api.github.com/repos/elixirland/xlc-book-club/git/blobs{/sha}",
        "git_tags_url": "https://api.github.com/repos/elixirland/xlc-book-club/git/tags{/sha}",
        "git_refs_url": "https://api.github.com/repos/elixirland/xlc-book-club/git/refs{/sha}",
        "trees_url": "https://api.github.com/repos/elixirland/xlc-book-club/git/trees{/sha}",
        "statuses_url": "https://api.github.com/repos/elixirland/xlc-book-club/statuses/{sha}",
        "languages_url": "https://api.github.com/repos/elixirland/xlc-book-club/languages",
        "stargazers_url": "https://api.github.com/repos/elixirland/xlc-book-club/stargazers",
        "contributors_url": "https://api.github.com/repos/elixirland/xlc-book-club/contributors",
        "subscribers_url": "https://api.github.com/repos/elixirland/xlc-book-club/subscribers",
        "subscription_url": "https://api.github.com/repos/elixirland/xlc-book-club/subscription",
        "commits_url": "https://api.github.com/repos/elixirland/xlc-book-club/commits{/sha}",
        "git_commits_url": "https://api.github.com/repos/elixirland/xlc-book-club/git/commits{/sha}",
        "comments_url": "https://api.github.com/repos/elixirland/xlc-book-club/comments{/number}",
        "issue_comment_url": "https://api.github.com/repos/elixirland/xlc-book-club/issues/comments{/number}",
        "contents_url": "https://api.github.com/repos/elixirland/xlc-book-club/contents/{+path}",
        "compare_url": "https://api.github.com/repos/elixirland/xlc-book-club/compare/{base}...{head}",
        "merges_url": "https://api.github.com/repos/elixirland/xlc-book-club/merges",
        "archive_url": "https://api.github.com/repos/elixirland/xlc-book-club/{archive_format}{/ref}",
        "downloads_url": "https://api.github.com/repos/elixirland/xlc-book-club/downloads",
        "issues_url": "https://api.github.com/repos/elixirland/xlc-book-club/issues{/number}",
        "pulls_url": "https://api.github.com/repos/elixirland/xlc-book-club/pulls{/number}",
        "milestones_url": "https://api.github.com/repos/elixirland/xlc-book-club/milestones{/number}",
        "notifications_url": "https://api.github.com/repos/elixirland/xlc-book-club/notifications{?since,all,participating}",
        "labels_url": "https://api.github.com/repos/elixirland/xlc-book-club/labels{/name}",
        "releases_url": "https://api.github.com/repos/elixirland/xlc-book-club/releases{/id}",
        "deployments_url": "https://api.github.com/repos/elixirland/xlc-book-club/deployments",
        "created_at": "2024-07-13T08:52:23Z",
        "updated_at": "2024-07-17T07:36:40Z",
        "pushed_at": "2024-07-17T07:36:37Z",
        "git_url": "git://github.com/elixirland/xlc-book-club.git",
        "ssh_url": "git@github.com:elixirland/xlc-book-club.git",
        "clone_url": "https://github.com/elixirland/xlc-book-club.git",
        "svn_url": "https://github.com/elixirland/xlc-book-club",
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
