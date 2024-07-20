defmodule XlWebsiteWeb.PageController do
  use XlWebsiteWeb, :controller
  alias XlWebsite.Parser

  @home "Home"
  @challenges "Challenges"
  @about "About"
  @repo_prefix "xlc-"

  def home(conn, _params) do
    conn
    |> assign(:page_title, @home)
    |> render(:home)
  end

  def challenges(conn, _params) do
    github_repos =
      get_repos()
      |> Parser.normalize_repos()

    conn
    |> assign(:page_title, @challenges)
    |> assign(:repos, github_repos)
    |> render(:challenges)
  end

  def challenge(conn, %{"slug" => slug}) do
    description =
      readme(slug)
      |> Parser.filter_description()

    name = Parser.slug_to_name(slug)

    conn
    |> assign(:page_title, name)
    |> assign(:name, name)
    |> assign(:slug, slug)
    |> assign(:repo_prefix, @repo_prefix)
    |> assign(:description, description)
    |> render(:challenge)
  end

  def about(conn, _params) do
    conn
    |> assign(:page_title, @about)
    |> render(:about)
  end

  # TODO: Replace hard-coded README.md with actual README.md

  def readme("username-generator") do
    """
    # Username Generator
    This is an Elixirland challenge. Read an introduction to Elixirland here: https://github.com/elixirland.

    ## Status
    This repository is **NOT REVIEWED** and **WORK IN PROGRESS**. This status will be set to "reviewed" when enough feedback has been given on the code and documentation in the `solution` directory.

    You can provide feedback by [opening an issue](https://github.com/elixirland/xlc-username-generator/issues/new) or contributing to this repository's [discussions](https://github.com/elixirland/xlc-username-generator/discussions).

    ## Description
    ### Background
    Saša recently joined a team of developers and volunteered to build a random username generator. The team’s software requires users to log in via third-party authorization (e.g., Google, Apple, GitHub), and each user must have a unique username. Initially, the team considered requiring users to choose their usernames upon first login, but they decided to assign random usernames instead. Users can change their usernames later in the settings.

    ### Task
    Develop a package that allows users to generate random usernames. Ensure your implementation meets the following requirements:
    - Adheres to idiomatic Elixir practices
    - Is well-tested
    - Is easily understandable by others, not just yourself

    ### Requirements
    #### Usernames
    - The generator must be able to generate at least 600,000 unique usernames
    - Usernames must consist of existing English words
    - Words in a username are separated by a hyphen (-) by default, with an option to choose other single-character delimiters

    #### Documentation
    - A detailed README.md that provides users with all the information they need
    - Includes instructions about how to install the package
    - Includes information about the limitations of the generator

    ## How to get started
    Fork this repository and implement your solution in the Mix app at the root directory. The solution by Elixirland is located in the directory `/solution`.

    Alternatively, you can start a new Mix app by using the command `mix new`. For more information, see the [mix new](https://hexdocs.pm/mix/1.12/Mix.Tasks.New.html) documentation.
    """
  end

  def readme("simple-chat-room") do
    """
    # Simple Chat Room
    This is an Elixirland challenge. Read an introduction to Elixirland here: https://github.com/elixirland.

    ## Status
    This repository is **NOT REVIEWED** and **WORK IN PROGRESS**. This status will be set to "reviewed" when enough feedback has been given on the code and documentation in the `solution` directory.

    You can provide feedback by [opening an issue](https://github.com/elixirland/xlc-simple-chat-room/issues/new) or contributing to this repository's [discussions](https://github.com/elixirland/xlc-simple-chat-room/discussions).

    ## Description
    ### Background

    ### Task
    Ensure your implementation meets the following requirements:
      - Adheres to idiomatic Elixir practices
      - Is well-tested
      - Is easily understandable by others, not just yourself

    ### Requirements

    ### Don't worry about
    To keep the challenge simple, you do not have to implement the following:


    ## How to get started
    Fork this repository and implement your solution in the Phoenix app at the root directory. The solution by Elixirland is located in the directory `/solution`.

    Alternatively, you can start a new Phoenix app by using the command `mix phx.new`. For more information, see the [mix phx.new](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.New.html) documentation.
    """
  end

  def readme("book-club") do
    """
    # Book Club
    This is an Elixirland challenge. Read an introduction to Elixirland here: https://github.com/elixirland.

    ## Status
    This repository is **NOT REVIEWED** and **WORK IN PROGRESS**. This status will be set to "reviewed" when enough feedback has been given on the code and documentation in the `solution` directory.

    You can provide feedback by [opening an issue](https://github.com/elixirland/xlc-book-club/issues/new) or contributing to this repository's [discussions](https://github.com/elixirland/xlc-book-club/discussions).

    ## Description
    ### Background
    Chris is a member of a book club and wants to develop a simple web API to streamline their group activities. His vision is to create a system that stores books and tracks the pages currently being read and discussed. The book club reads multiple books simultaneously. Although there is already a system in place for tracking who is reading which books, there is no easy way to find the current page being read in any given book.

    ### Task
    Develop a Phoenix app that models books and their pages and exposes two endpoints through an API. Ensure your implementation meets the following requirements:
      - Adheres to idiomatic Elixir practices
      - Is well-tested
      - Is easily understandable by others, not just yourself

    ### Requirements
    #### Data model
      - Books and pages are stored in a PostgreSQL database
      - Each book has a title
      - Each book can have multiple pages
      - Each page has text-only content
      - A book can have one active page (or none)

    #### Seeding
      - Running `mix ecto.setup` creates the database tables but also seeds the database
      - Seeding inserts 4,000 books that each have 10 pages
      - Some seeded books have an active page, but not all
      - Seeding is fast

    **Note**: You can use Elixirland's [Xl Faker](https://hex.pm/packages/xl_faker) package to generate random titles and page content.

    #### Endpoints
    ##### GET `/api/books`
      - An endpoint that fetching all books in the alphabetical order of their titles
      - Retrieves the books along with their active pages, or if non exisits, their first pages
      - Allows for filtering by partial book title
      - Returns JSON

    ##### GET `/api/books/:id`
      - An endpoint for fetching a specific book
      - Retrieves the book along with its active page, or if non exisits, its first page
      - Returns JSON

    #### README
      - A detailed manual that provides users with all the information they need
      - Includes information about what is stored in the database
      - Includes instructions about how to run and seed the app
      - Includes instructions how to use the endpoints

    ### Don't worry about
    To keep the challenge simple, you do not have to implement the following:

      - Client authentication and/or authorization
      - Rate limiting
      - Formatting of page text content
      - Pagination

    ## How to get started
    Fork this repository and implement your solution in the Phoenix app at the root directory. The solution by Elixirland is located in the directory `/solution`.

    Alternatively, you can start a new Phoenix app by using the command `mix phx.new`. For more information, see the [mix phx.new](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.New.html) documentation.
    """
  end

  # TODO: Replace hard-coded repo info with actual repo info

  def get_repos() do
    """
    [
      {
        "id": 828144262,
        "node_id": "R_kgDOMVx6hg",
        "name": "elixirland",
        "full_name": "elixirland/elixirland",
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
        "html_url": "https://github.com/elixirland/elixirland",
        "description": "Introduction to Elixirland",
        "fork": false,
        "url": "https://api.github.com/repos/elixirland/elixirland",
        "forks_url": "https://api.github.com/repos/elixirland/elixirland/forks",
        "keys_url": "https://api.github.com/repos/elixirland/elixirland/keys{/key_id}",
        "collaborators_url": "https://api.github.com/repos/elixirland/elixirland/collaborators{/collaborator}",
        "teams_url": "https://api.github.com/repos/elixirland/elixirland/teams",
        "hooks_url": "https://api.github.com/repos/elixirland/elixirland/hooks",
        "issue_events_url": "https://api.github.com/repos/elixirland/elixirland/issues/events{/number}",
        "events_url": "https://api.github.com/repos/elixirland/elixirland/events",
        "assignees_url": "https://api.github.com/repos/elixirland/elixirland/assignees{/user}",
        "branches_url": "https://api.github.com/repos/elixirland/elixirland/branches{/branch}",
        "tags_url": "https://api.github.com/repos/elixirland/elixirland/tags",
        "blobs_url": "https://api.github.com/repos/elixirland/elixirland/git/blobs{/sha}",
        "git_tags_url": "https://api.github.com/repos/elixirland/elixirland/git/tags{/sha}",
        "git_refs_url": "https://api.github.com/repos/elixirland/elixirland/git/refs{/sha}",
        "trees_url": "https://api.github.com/repos/elixirland/elixirland/git/trees{/sha}",
        "statuses_url": "https://api.github.com/repos/elixirland/elixirland/statuses/{sha}",
        "languages_url": "https://api.github.com/repos/elixirland/elixirland/languages",
        "stargazers_url": "https://api.github.com/repos/elixirland/elixirland/stargazers",
        "contributors_url": "https://api.github.com/repos/elixirland/elixirland/contributors",
        "subscribers_url": "https://api.github.com/repos/elixirland/elixirland/subscribers",
        "subscription_url": "https://api.github.com/repos/elixirland/elixirland/subscription",
        "commits_url": "https://api.github.com/repos/elixirland/elixirland/commits{/sha}",
        "git_commits_url": "https://api.github.com/repos/elixirland/elixirland/git/commits{/sha}",
        "comments_url": "https://api.github.com/repos/elixirland/elixirland/comments{/number}",
        "issue_comment_url": "https://api.github.com/repos/elixirland/elixirland/issues/comments{/number}",
        "contents_url": "https://api.github.com/repos/elixirland/elixirland/contents/{+path}",
        "compare_url": "https://api.github.com/repos/elixirland/elixirland/compare/{base}...{head}",
        "merges_url": "https://api.github.com/repos/elixirland/elixirland/merges",
        "archive_url": "https://api.github.com/repos/elixirland/elixirland/{archive_format}{/ref}",
        "downloads_url": "https://api.github.com/repos/elixirland/elixirland/downloads",
        "issues_url": "https://api.github.com/repos/elixirland/elixirland/issues{/number}",
        "pulls_url": "https://api.github.com/repos/elixirland/elixirland/pulls{/number}",
        "milestones_url": "https://api.github.com/repos/elixirland/elixirland/milestones{/number}",
        "notifications_url": "https://api.github.com/repos/elixirland/elixirland/notifications{?since,all,participating}",
        "labels_url": "https://api.github.com/repos/elixirland/elixirland/labels{/name}",
        "releases_url": "https://api.github.com/repos/elixirland/elixirland/releases{/id}",
        "deployments_url": "https://api.github.com/repos/elixirland/elixirland/deployments",
        "created_at": "2024-07-13T08:49:12Z",
        "updated_at": "2024-07-18T18:51:10Z",
        "pushed_at": "2024-07-18T18:51:08Z",
        "git_url": "git://github.com/elixirland/elixirland.git",
        "ssh_url": "git@github.com:elixirland/elixirland.git",
        "clone_url": "https://github.com/elixirland/elixirland.git",
        "svn_url": "https://github.com/elixirland/elixirland",
        "homepage": "https://elixirland.dev",
        "size": 27,
        "stargazers_count": 2,
        "watchers_count": 2,
        "language": null,
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

        ],
        "visibility": "public",
        "forks": 0,
        "open_issues": 0,
        "watchers": 2,
        "default_branch": "main"
      },
      {
        "id": 828204085,
        "node_id": "R_kgDOMV1kNQ",
        "name": "xl-faker",
        "full_name": "elixirland/xl-faker",
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
        "html_url": "https://github.com/elixirland/xl-faker",
        "description": "A package for generating fake data, convenient for use in Elixirland challenges.",
        "fork": false,
        "url": "https://api.github.com/repos/elixirland/xl-faker",
        "forks_url": "https://api.github.com/repos/elixirland/xl-faker/forks",
        "keys_url": "https://api.github.com/repos/elixirland/xl-faker/keys{/key_id}",
        "collaborators_url": "https://api.github.com/repos/elixirland/xl-faker/collaborators{/collaborator}",
        "teams_url": "https://api.github.com/repos/elixirland/xl-faker/teams",
        "hooks_url": "https://api.github.com/repos/elixirland/xl-faker/hooks",
        "issue_events_url": "https://api.github.com/repos/elixirland/xl-faker/issues/events{/number}",
        "events_url": "https://api.github.com/repos/elixirland/xl-faker/events",
        "assignees_url": "https://api.github.com/repos/elixirland/xl-faker/assignees{/user}",
        "branches_url": "https://api.github.com/repos/elixirland/xl-faker/branches{/branch}",
        "tags_url": "https://api.github.com/repos/elixirland/xl-faker/tags",
        "blobs_url": "https://api.github.com/repos/elixirland/xl-faker/git/blobs{/sha}",
        "git_tags_url": "https://api.github.com/repos/elixirland/xl-faker/git/tags{/sha}",
        "git_refs_url": "https://api.github.com/repos/elixirland/xl-faker/git/refs{/sha}",
        "trees_url": "https://api.github.com/repos/elixirland/xl-faker/git/trees{/sha}",
        "statuses_url": "https://api.github.com/repos/elixirland/xl-faker/statuses/{sha}",
        "languages_url": "https://api.github.com/repos/elixirland/xl-faker/languages",
        "stargazers_url": "https://api.github.com/repos/elixirland/xl-faker/stargazers",
        "contributors_url": "https://api.github.com/repos/elixirland/xl-faker/contributors",
        "subscribers_url": "https://api.github.com/repos/elixirland/xl-faker/subscribers",
        "subscription_url": "https://api.github.com/repos/elixirland/xl-faker/subscription",
        "commits_url": "https://api.github.com/repos/elixirland/xl-faker/commits{/sha}",
        "git_commits_url": "https://api.github.com/repos/elixirland/xl-faker/git/commits{/sha}",
        "comments_url": "https://api.github.com/repos/elixirland/xl-faker/comments{/number}",
        "issue_comment_url": "https://api.github.com/repos/elixirland/xl-faker/issues/comments{/number}",
        "contents_url": "https://api.github.com/repos/elixirland/xl-faker/contents/{+path}",
        "compare_url": "https://api.github.com/repos/elixirland/xl-faker/compare/{base}...{head}",
        "merges_url": "https://api.github.com/repos/elixirland/xl-faker/merges",
        "archive_url": "https://api.github.com/repos/elixirland/xl-faker/{archive_format}{/ref}",
        "downloads_url": "https://api.github.com/repos/elixirland/xl-faker/downloads",
        "issues_url": "https://api.github.com/repos/elixirland/xl-faker/issues{/number}",
        "pulls_url": "https://api.github.com/repos/elixirland/xl-faker/pulls{/number}",
        "milestones_url": "https://api.github.com/repos/elixirland/xl-faker/milestones{/number}",
        "notifications_url": "https://api.github.com/repos/elixirland/xl-faker/notifications{?since,all,participating}",
        "labels_url": "https://api.github.com/repos/elixirland/xl-faker/labels{/name}",
        "releases_url": "https://api.github.com/repos/elixirland/xl-faker/releases{/id}",
        "deployments_url": "https://api.github.com/repos/elixirland/xl-faker/deployments",
        "created_at": "2024-07-13T12:30:13Z",
        "updated_at": "2024-07-19T10:48:16Z",
        "pushed_at": "2024-07-15T20:14:06Z",
        "git_url": "git://github.com/elixirland/xl-faker.git",
        "ssh_url": "git@github.com:elixirland/xl-faker.git",
        "clone_url": "https://github.com/elixirland/xl-faker.git",
        "svn_url": "https://github.com/elixirland/xl-faker",
        "homepage": "https://hex.pm/packages/xl_faker",
        "size": 93,
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
        "license": {
          "key": "mit",
          "name": "MIT License",
          "spdx_id": "MIT",
          "url": "https://api.github.com/licenses/mit",
          "node_id": "MDc6TGljZW5zZTEz"
        },
        "allow_forking": true,
        "is_template": false,
        "web_commit_signoff_required": false,
        "topics": [

        ],
        "visibility": "public",
        "forks": 0,
        "open_issues": 0,
        "watchers": 0,
        "default_branch": "main"
      },
      {
        "id": 830698065,
        "node_id": "R_kgDOMYNyUQ",
        "name": "xl-template",
        "full_name": "elixirland/xl-template",
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
        "html_url": "https://github.com/elixirland/xl-template",
        "description": "Template for challenge repositories",
        "fork": false,
        "url": "https://api.github.com/repos/elixirland/xl-template",
        "forks_url": "https://api.github.com/repos/elixirland/xl-template/forks",
        "keys_url": "https://api.github.com/repos/elixirland/xl-template/keys{/key_id}",
        "collaborators_url": "https://api.github.com/repos/elixirland/xl-template/collaborators{/collaborator}",
        "teams_url": "https://api.github.com/repos/elixirland/xl-template/teams",
        "hooks_url": "https://api.github.com/repos/elixirland/xl-template/hooks",
        "issue_events_url": "https://api.github.com/repos/elixirland/xl-template/issues/events{/number}",
        "events_url": "https://api.github.com/repos/elixirland/xl-template/events",
        "assignees_url": "https://api.github.com/repos/elixirland/xl-template/assignees{/user}",
        "branches_url": "https://api.github.com/repos/elixirland/xl-template/branches{/branch}",
        "tags_url": "https://api.github.com/repos/elixirland/xl-template/tags",
        "blobs_url": "https://api.github.com/repos/elixirland/xl-template/git/blobs{/sha}",
        "git_tags_url": "https://api.github.com/repos/elixirland/xl-template/git/tags{/sha}",
        "git_refs_url": "https://api.github.com/repos/elixirland/xl-template/git/refs{/sha}",
        "trees_url": "https://api.github.com/repos/elixirland/xl-template/git/trees{/sha}",
        "statuses_url": "https://api.github.com/repos/elixirland/xl-template/statuses/{sha}",
        "languages_url": "https://api.github.com/repos/elixirland/xl-template/languages",
        "stargazers_url": "https://api.github.com/repos/elixirland/xl-template/stargazers",
        "contributors_url": "https://api.github.com/repos/elixirland/xl-template/contributors",
        "subscribers_url": "https://api.github.com/repos/elixirland/xl-template/subscribers",
        "subscription_url": "https://api.github.com/repos/elixirland/xl-template/subscription",
        "commits_url": "https://api.github.com/repos/elixirland/xl-template/commits{/sha}",
        "git_commits_url": "https://api.github.com/repos/elixirland/xl-template/git/commits{/sha}",
        "comments_url": "https://api.github.com/repos/elixirland/xl-template/comments{/number}",
        "issue_comment_url": "https://api.github.com/repos/elixirland/xl-template/issues/comments{/number}",
        "contents_url": "https://api.github.com/repos/elixirland/xl-template/contents/{+path}",
        "compare_url": "https://api.github.com/repos/elixirland/xl-template/compare/{base}...{head}",
        "merges_url": "https://api.github.com/repos/elixirland/xl-template/merges",
        "archive_url": "https://api.github.com/repos/elixirland/xl-template/{archive_format}{/ref}",
        "downloads_url": "https://api.github.com/repos/elixirland/xl-template/downloads",
        "issues_url": "https://api.github.com/repos/elixirland/xl-template/issues{/number}",
        "pulls_url": "https://api.github.com/repos/elixirland/xl-template/pulls{/number}",
        "milestones_url": "https://api.github.com/repos/elixirland/xl-template/milestones{/number}",
        "notifications_url": "https://api.github.com/repos/elixirland/xl-template/notifications{?since,all,participating}",
        "labels_url": "https://api.github.com/repos/elixirland/xl-template/labels{/name}",
        "releases_url": "https://api.github.com/repos/elixirland/xl-template/releases{/id}",
        "deployments_url": "https://api.github.com/repos/elixirland/xl-template/deployments",
        "created_at": "2024-07-18T19:49:37Z",
        "updated_at": "2024-07-18T19:49:45Z",
        "pushed_at": "2024-07-18T19:49:37Z",
        "git_url": "git://github.com/elixirland/xl-template.git",
        "ssh_url": "git@github.com:elixirland/xl-template.git",
        "clone_url": "https://github.com/elixirland/xl-template.git",
        "svn_url": "https://github.com/elixirland/xl-template",
        "homepage": null,
        "size": 0,
        "stargazers_count": 0,
        "watchers_count": 0,
        "language": null,
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
        "is_template": true,
        "web_commit_signoff_required": false,
        "topics": [

        ],
        "visibility": "public",
        "forks": 0,
        "open_issues": 0,
        "watchers": 0,
        "default_branch": "main"
      },
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
        "description": "Build an simple Phoenix API for a book club.",
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
        "updated_at": "2024-07-19T11:25:04Z",
        "pushed_at": "2024-07-19T11:25:01Z",
        "git_url": "git://github.com/elixirland/xlc-book-club.git",
        "ssh_url": "git@github.com:elixirland/xlc-book-club.git",
        "clone_url": "https://github.com/elixirland/xlc-book-club.git",
        "svn_url": "https://github.com/elixirland/xlc-book-club",
        "homepage": "",
        "size": 403,
        "stargazers_count": 1,
        "watchers_count": 1,
        "language": "Elixir",
        "has_issues": true,
        "has_projects": false,
        "has_downloads": true,
        "has_wiki": false,
        "has_pages": false,
        "has_discussions": true,
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
          "api",
          "ecto",
          "elixir",
          "phoenix",
          "postgresql"
        ],
        "visibility": "public",
        "forks": 0,
        "open_issues": 0,
        "watchers": 1,
        "default_branch": "main"
      },
      {
        "id": 830974554,
        "node_id": "R_kgDOMYeqWg",
        "name": "xlc-simple-chat-room",
        "full_name": "elixirland/xlc-simple-chat-room",
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
        "html_url": "https://github.com/elixirland/xlc-simple-chat-room",
        "description": "Build a simple chat room with LiveView.",
        "fork": false,
        "url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room",
        "forks_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/forks",
        "keys_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/keys{/key_id}",
        "collaborators_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/collaborators{/collaborator}",
        "teams_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/teams",
        "hooks_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/hooks",
        "issue_events_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/issues/events{/number}",
        "events_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/events",
        "assignees_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/assignees{/user}",
        "branches_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/branches{/branch}",
        "tags_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/tags",
        "blobs_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/git/blobs{/sha}",
        "git_tags_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/git/tags{/sha}",
        "git_refs_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/git/refs{/sha}",
        "trees_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/git/trees{/sha}",
        "statuses_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/statuses/{sha}",
        "languages_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/languages",
        "stargazers_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/stargazers",
        "contributors_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/contributors",
        "subscribers_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/subscribers",
        "subscription_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/subscription",
        "commits_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/commits{/sha}",
        "git_commits_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/git/commits{/sha}",
        "comments_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/comments{/number}",
        "issue_comment_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/issues/comments{/number}",
        "contents_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/contents/{+path}",
        "compare_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/compare/{base}...{head}",
        "merges_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/merges",
        "archive_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/{archive_format}{/ref}",
        "downloads_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/downloads",
        "issues_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/issues{/number}",
        "pulls_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/pulls{/number}",
        "milestones_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/milestones{/number}",
        "notifications_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/notifications{?since,all,participating}",
        "labels_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/labels{/name}",
        "releases_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/releases{/id}",
        "deployments_url": "https://api.github.com/repos/elixirland/xlc-simple-chat-room/deployments",
        "created_at": "2024-07-19T11:24:22Z",
        "updated_at": "2024-07-19T11:27:59Z",
        "pushed_at": "2024-07-19T11:26:50Z",
        "git_url": "git://github.com/elixirland/xlc-simple-chat-room.git",
        "ssh_url": "git@github.com:elixirland/xlc-simple-chat-room.git",
        "clone_url": "https://github.com/elixirland/xlc-simple-chat-room.git",
        "svn_url": "https://github.com/elixirland/xlc-simple-chat-room",
        "homepage": "",
        "size": 0,
        "stargazers_count": 0,
        "watchers_count": 0,
        "language": null,
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
          "liveview",
          "phoenix",
          "postgresql"
        ],
        "visibility": "public",
        "forks": 0,
        "open_issues": 0,
        "watchers": 0,
        "default_branch": "main"
      },
      {
        "id": 830696485,
        "node_id": "R_kgDOMYNsJQ",
        "name": "xlc-username-generator",
        "full_name": "elixirland/xlc-username-generator",
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
        "html_url": "https://github.com/elixirland/xlc-username-generator",
        "description": "Build a Hex package that generates random usernames.",
        "fork": false,
        "url": "https://api.github.com/repos/elixirland/xlc-username-generator",
        "forks_url": "https://api.github.com/repos/elixirland/xlc-username-generator/forks",
        "keys_url": "https://api.github.com/repos/elixirland/xlc-username-generator/keys{/key_id}",
        "collaborators_url": "https://api.github.com/repos/elixirland/xlc-username-generator/collaborators{/collaborator}",
        "teams_url": "https://api.github.com/repos/elixirland/xlc-username-generator/teams",
        "hooks_url": "https://api.github.com/repos/elixirland/xlc-username-generator/hooks",
        "issue_events_url": "https://api.github.com/repos/elixirland/xlc-username-generator/issues/events{/number}",
        "events_url": "https://api.github.com/repos/elixirland/xlc-username-generator/events",
        "assignees_url": "https://api.github.com/repos/elixirland/xlc-username-generator/assignees{/user}",
        "branches_url": "https://api.github.com/repos/elixirland/xlc-username-generator/branches{/branch}",
        "tags_url": "https://api.github.com/repos/elixirland/xlc-username-generator/tags",
        "blobs_url": "https://api.github.com/repos/elixirland/xlc-username-generator/git/blobs{/sha}",
        "git_tags_url": "https://api.github.com/repos/elixirland/xlc-username-generator/git/tags{/sha}",
        "git_refs_url": "https://api.github.com/repos/elixirland/xlc-username-generator/git/refs{/sha}",
        "trees_url": "https://api.github.com/repos/elixirland/xlc-username-generator/git/trees{/sha}",
        "statuses_url": "https://api.github.com/repos/elixirland/xlc-username-generator/statuses/{sha}",
        "languages_url": "https://api.github.com/repos/elixirland/xlc-username-generator/languages",
        "stargazers_url": "https://api.github.com/repos/elixirland/xlc-username-generator/stargazers",
        "contributors_url": "https://api.github.com/repos/elixirland/xlc-username-generator/contributors",
        "subscribers_url": "https://api.github.com/repos/elixirland/xlc-username-generator/subscribers",
        "subscription_url": "https://api.github.com/repos/elixirland/xlc-username-generator/subscription",
        "commits_url": "https://api.github.com/repos/elixirland/xlc-username-generator/commits{/sha}",
        "git_commits_url": "https://api.github.com/repos/elixirland/xlc-username-generator/git/commits{/sha}",
        "comments_url": "https://api.github.com/repos/elixirland/xlc-username-generator/comments{/number}",
        "issue_comment_url": "https://api.github.com/repos/elixirland/xlc-username-generator/issues/comments{/number}",
        "contents_url": "https://api.github.com/repos/elixirland/xlc-username-generator/contents/{+path}",
        "compare_url": "https://api.github.com/repos/elixirland/xlc-username-generator/compare/{base}...{head}",
        "merges_url": "https://api.github.com/repos/elixirland/xlc-username-generator/merges",
        "archive_url": "https://api.github.com/repos/elixirland/xlc-username-generator/{archive_format}{/ref}",
        "downloads_url": "https://api.github.com/repos/elixirland/xlc-username-generator/downloads",
        "issues_url": "https://api.github.com/repos/elixirland/xlc-username-generator/issues{/number}",
        "pulls_url": "https://api.github.com/repos/elixirland/xlc-username-generator/pulls{/number}",
        "milestones_url": "https://api.github.com/repos/elixirland/xlc-username-generator/milestones{/number}",
        "notifications_url": "https://api.github.com/repos/elixirland/xlc-username-generator/notifications{?since,all,participating}",
        "labels_url": "https://api.github.com/repos/elixirland/xlc-username-generator/labels{/name}",
        "releases_url": "https://api.github.com/repos/elixirland/xlc-username-generator/releases{/id}",
        "deployments_url": "https://api.github.com/repos/elixirland/xlc-username-generator/deployments",
        "created_at": "2024-07-18T19:44:24Z",
        "updated_at": "2024-07-19T11:16:46Z",
        "pushed_at": "2024-07-19T11:16:42Z",
        "git_url": "git://github.com/elixirland/xlc-username-generator.git",
        "ssh_url": "git@github.com:elixirland/xlc-username-generator.git",
        "clone_url": "https://github.com/elixirland/xlc-username-generator.git",
        "svn_url": "https://github.com/elixirland/xlc-username-generator",
        "homepage": "",
        "size": 571,
        "stargazers_count": 0,
        "watchers_count": 0,
        "language": null,
        "has_issues": true,
        "has_projects": false,
        "has_downloads": true,
        "has_wiki": true,
        "has_pages": false,
        "has_discussions": true,
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
          "hex",
          "mix"
        ],
        "visibility": "public",
        "forks": 0,
        "open_issues": 0,
        "watchers": 0,
        "default_branch": "main"
      }
    ]
    """
    |> Jason.decode!()
  end
end
