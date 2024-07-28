# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     XlWebsite.Repo.insert!(%XlWebsite.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias XlWebsite.Repo

Repo.insert!(%XlWebsite.Exercises.Exercise{
  full_name: "elixirland/xle-book-club",
  name: "Book Club",
  slug: "book-club",
  html_url: "https://github.com/elixirland/xle-book-club",
  topics: ["Elixir", "Phoenix"],
  description: "Build an simple Phoenix API for a book club.",
  readme_md: ~s|# Some Exercise Name\nSome text.\n\n## Status\nExercise: ***Not Reviewed***\nSolution: ***Not Reviewed***\n\n> [!NOTE]> Some note.\n\n## Introduction\nSome text.\n\n## Task\nSome text.\n\n## Requirements\n### Some heading\n  - Some list.\n\n> [!TIP]\n> Some tip.\n\n## How to get started\nSome text.\n\n## Example solution\nSome text.|
})

Repo.insert!(%XlWebsite.Exercises.Exercise{
  full_name: "elixirland/xle-username-generator",
  name: "Username Generator",
  slug: "username-generator",
  html_url: "https://github.com/elixirland/xle-username-generator",
  topics: ["Elixir", "Hex"],
  description: "Build a Hex package that generates random usernames.",
  readme_md: ~s|# Some Exercise Name\nSome text.\n\n## Status\nExercise: ***Not Reviewed***\nSolution: ***Not Reviewed***\n\n> [!NOTE]> Some note.\n\n## Introduction\nSome text.\n\n## Task\nSome text.\n\n## Requirements\n### Some heading\n  - Some list.\n\n> [!TIP]\n> Some tip.\n\n## How to get started\nSome text.\n\n## Example solution\nSome text.|
})

Repo.insert!(%XlWebsite.Exercises.Exercise{
  full_name: "elixirland/xle-simple-chat-room",
  name: "Simple Chat Room",
  slug: "simple-chat-room",
  html_url: "http://github.com/elixirland/xle-simple-chat-room",
  topics: ["Elixir", "Phoenix"],
  description: "Build a simple chat room using Phoenix LiveView.",
  readme_md: ~s|# Some Exercise Name\nSome text.\n\n## Status\nExercise: ***Not Reviewed***\nSolution: ***Not Reviewed***\n\n> [!NOTE]> Some note.\n\n## Introduction\nSome text.\n\n## Task\nSome text.\n\n## Requirements\n### Some heading\n  - Some list.\n\n> [!TIP]\n> Some tip.\n\n## How to get started\nSome text.\n\n## Example solution\nSome text.|
})
