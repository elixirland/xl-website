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

readme =
  """
  # Some Exercise Name
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare tempus enim, quis consequat nisl congue volutpat. Nunc in nisi id nisl consectetur viverra.

  Vivamus euismod, diam in iaculis feugiat, augue augue pharetra ipsum, non dictum est eros vitae orci. Quisque in leo risus. Mauris ultrices augue a sagittis pellentesque. Aliquam pretium nulla justo, non lobortis nibh bibendum non. Praesent orci sapien, tempus ut felis eget, mattis ultrices ipsum. Suspendisse facilisis dictum lacus, faucibus euismod lectus condimentum non.

  ## Status
  Exercise: ***Not Reviewed***
  Solution: ***Not Reviewed***

  > [!NOTE]> Some note.

  ## Introduction
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare tempus enim, quis consequat nisl congue volutpat. Nunc in nisi id nisl consectetur viverra.

  Vivamus euismod, diam in iaculis feugiat, augue augue pharetra ipsum, non dictum est eros vitae orci. Quisque in leo risus. Mauris ultrices augue a sagittis pellentesque. Aliquam pretium nulla justo, non lobortis nibh bibendum non. Praesent orci sapien, tempus ut felis eget, mattis ultrices ipsum. Suspendisse facilisis dictum lacus, faucibus euismod lectus condimentum non.

  ## Task
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare tempus enim, quis consequat nisl congue volutpat. Nunc in nisi id nisl consectetur viverra.

  Vivamus euismod, diam in iaculis feugiat, augue augue pharetra ipsum, non dictum est eros vitae orci. Quisque in leo risus. Mauris ultrices augue a sagittis pellentesque. Aliquam pretium nulla justo, non lobortis nibh bibendum non. Praesent orci sapien, tempus ut felis eget, mattis ultrices ipsum. Suspendisse facilisis dictum lacus, faucibus euismod lectus condimentum non.

  ## Requirements
  ### Some heading
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare tempus enim, quis consequat nisl congue volutpat. Nunc in nisi id nisl consectetur viverra.

  Vivamus euismod, diam in iaculis feugiat, augue augue pharetra ipsum, non dictum est eros vitae orci. Quisque in leo risus. Mauris ultrices augue a sagittis pellentesque. Aliquam pretium nulla justo, non lobortis nibh bibendum non. Praesent orci sapien, tempus ut felis eget, mattis ultrices ipsum. Suspendisse facilisis dictum lacus, faucibus euismod lectus condimentum non.

  - Some requirement
  - Another requirement
  - Yet another requirement

  > [!TIP]
  > Some tip.

  ## How to get started
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare tempus enim, quis consequat nisl congue volutpat. Nunc in nisi id nisl consectetur viverra.

  Vivamus euismod, diam in iaculis feugiat, augue augue pharetra ipsum, non dictum est eros vitae orci. Quisque in leo risus. Mauris ultrices augue a sagittis pellentesque. Aliquam pretium nulla justo, non lobortis nibh bibendum non. Praesent orci sapien, tempus ut felis eget, mattis ultrices ipsum. Suspendisse facilisis dictum lacus, faucibus euismod lectus condimentum non.

  ## Example solution
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare tempus enim, quis consequat nisl congue volutpat. Nunc in nisi id nisl consectetur viverra.

  Vivamus euismod, diam in iaculis feugiat, augue augue pharetra ipsum, non dictum est eros vitae orci. Quisque in leo risus. Mauris ultrices augue a sagittis pellentesque. Aliquam pretium nulla justo, non lobortis nibh bibendum non. Praesent orci sapien, tempus ut felis eget, mattis ultrices ipsum. Suspendisse facilisis dictum lacus, faucibus euismod lectus condimentum non.
  """

Repo.insert!(%XlWebsite.Exercises.Exercise{
  full_name: "elixirland/xle-book-club",
  name: "Book Club",
  slug: "book-club",
  html_url: "https://github.com/elixirland/xle-book-club",
  topics: ["Elixir", "Phoenix"],
  description: "Build an simple Phoenix API for a book club.",
  readme: readme
})

Repo.insert!(%XlWebsite.Exercises.Exercise{
  full_name: "elixirland/xle-username-generator",
  name: "Username Generator",
  slug: "username-generator",
  html_url: "https://github.com/elixirland/xle-username-generator",
  topics: ["Elixir", "Hex"],
  description: "Build a Hex package that generates random usernames.",
  readme: readme
})

Repo.insert!(%XlWebsite.Exercises.Exercise{
  full_name: "elixirland/xle-simple-chat-room",
  name: "Simple Chat Room",
  slug: "simple-chat-room",
  html_url: "http://github.com/elixirland/xle-simple-chat-room",
  topics: ["Elixir", "Phoenix"],
  description: "Build a simple chat room using Phoenix LiveView.",
  readme: readme
})
