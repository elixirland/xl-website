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
alias XlWebsite.Projects.Project
alias XlWebsite.Ecosystem

# Insert projects

readme =
  """
  # Some Project Name
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare tempus enim, quis consequat nisl congue volutpat. Nunc in nisi id nisl consectetur viverra.

  Vivamus euismod, diam in iaculis feugiat, augue augue pharetra ipsum, non dictum est eros vitae orci. Quisque in leo risus. Mauris ultrices augue a sagittis pellentesque. Aliquam pretium nulla justo, non lobortis nibh bibendum non. Praesent orci sapien, tempus ut felis eget, mattis ultrices ipsum. Suspendisse facilisis dictum lacus, faucibus euismod lectus condimentum non.

  ## Introduction
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare tempus enim, quis consequat nisl congue volutpat. Nunc in nisi id nisl consectetur viverra.

  Vivamus euismod, diam in iaculis feugiat, augue augue pharetra ipsum, non dictum est eros vitae orci. Quisque in leo risus. Mauris ultrices augue a sagittis pellentesque. Aliquam pretium nulla justo, non lobortis nibh bibendum non. Praesent orci sapien, tempus ut felis eget, mattis ultrices ipsum. Suspendisse facilisis dictum lacus, faucibus euismod lectus condimentum non.

  ## Preview
  https://github.com/elixirland/xlp-book-club-API/raw/main/preview.webm

  ## Task description
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

  ## Assumptions
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare tempus enim, quis consequat nisl congue volutpat. Nunc in nisi id nisl consectetur viverra.

  ## How to get started
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare tempus enim, quis consequat nisl congue volutpat. Nunc in nisi id nisl consectetur viverra.

  Vivamus euismod, diam in iaculis feugiat, augue augue pharetra ipsum, non dictum est eros vitae orci. Quisque in leo risus. Mauris ultrices augue a sagittis pellentesque. Aliquam pretium nulla justo, non lobortis nibh bibendum non. Praesent orci sapien, tempus ut felis eget, mattis ultrices ipsum. Suspendisse facilisis dictum lacus, faucibus euismod lectus condimentum non.

  ## Example
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare tempus enim, quis consequat nisl congue volutpat. Nunc in nisi id nisl consectetur viverra.

  Vivamus euismod, diam in iaculis feugiat, augue augue pharetra ipsum, non dictum est eros vitae orci. Quisque in leo risus. Mauris ultrices augue a sagittis pellentesque. Aliquam pretium nulla justo, non lobortis nibh bibendum non. Praesent orci sapien, tempus ut felis eget, mattis ultrices ipsum. Suspendisse facilisis dictum lacus, faucibus euismod lectus condimentum non.
  """

Repo.insert!(%Project{
  full_name: "elixirland/xlp-book-club-API",
  name: "Book Club API",
  slug: "book-club-API",
  html_url: "https://github.com/elixirland/xlp-book-club-API",
  topics: ["Elixir", "Phoenix"],
  description: "Build a simple Phoenix API for a book club.",
  readme: readme
})

Repo.insert!(%Project{
  full_name: "elixirland/xlp-username-generator",
  name: "Username Generator",
  slug: "username-generator",
  html_url: "https://github.com/elixirland/xlp-username-generator",
  topics: ["Elixir", "Hex"],
  description: "Build a Hex package that generates random usernames.",
  readme: readme
})

Repo.insert!(%Project{
  full_name: "elixirland/xlp-simple-chat-room",
  name: "Simple Chat Room",
  slug: "simple-chat-room",
  html_url: "http://github.com/elixirland/xlp-simple-chat-room",
  topics: ["Elixir", "Phoenix"],
  description: "Build a simple chat room using Phoenix LiveView.",
  readme: readme
})

# Insert ecosystem categories and tools

the_web_category =
  Repo.insert!(%Ecosystem.Category{
    name: "The Web"
  })

Repo.insert!(%Ecosystem.Tool{
  name: "Phoenix Framework",
  description:
    "Phoenix is a popular web development framework for building web applications with Elixir.\n\nServer-side rendering and real-time communication, are some of its key features. Has LiveView built-in, allowing developers to build interactive, real-time applications while writing little to no JavaScript.\n\n[Documentation](https://hexdocs.pm/phoenix_live_view/welcome.html)",
  category_id: the_web_category.id
})

Repo.insert!(%Ecosystem.Tool{
  name: "Plug",
  description:
    "Surface is a component library for Phoenix LiveView that allows you to build interactive, real-time applications while writing little to no JavaScript.",
  category_id: the_web_category.id
})

native_applications_category =
  Repo.insert!(%Ecosystem.Category{
    name: "Other Tools"
  })

Repo.insert!(%Ecosystem.Tool{
  name: "Scenic",
  description:
    "Scenic is an application framework written directly on the Elixir/Erlang/OTP stack. With it, you can build client-side applications that operate identically across all supported operating systems, including MacOS, Ubuntu, Nerves/Linux, and more.",
  category_id: native_applications_category.id
})

Repo.insert!(%Ecosystem.Tool{
  name: "LiveView Native",
  description:
    "LiveView Native allows you to build LiveView apps that have a front-end for multiple platforms. Use your LiveView back-end to create a web, mobile, wearable and/or desktop UI.",
  category_id: native_applications_category.id
})
