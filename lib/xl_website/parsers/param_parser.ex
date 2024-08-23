defmodule XlWebsite.ParamParser do
  @topic_hashes %{
    "api" => "API",
    "postgresql" => "PostgreSQL"
  }
  @topic_hash_keys Map.keys(@topic_hashes)
  @repo_prefix "xle-"

  def parse_body_params(conn, _opts \\ []) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    {:ok, body, Plug.Conn.put_private(conn, :raw_body, body)}
  end

  def build_name(full_name) do
    full_name
    |> String.split("/")
    |> List.last()
    |> String.replace(@repo_prefix, "")
    |> String.split("-")
    |> Enum.map(&maybe_capitalize/1)
    |> Enum.join(" ")
  end

  defp maybe_capitalize(word) do
    case all_lowercase?(word) do
      true -> String.capitalize(word)
      false -> word
    end
  end

  defp all_lowercase?(word) do
    word == String.downcase(word)
  end

  def build_slug(full_name) do
    full_name
    |> String.split("/")
    |> List.last()
    |> String.replace(@repo_prefix, "")
  end

  def slug_to_name(slug) do
    slug
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def parse_topics(topics) do
    topics
    |> Enum.map(&String.downcase/1)
    |> Enum.map(&parse_topic/1)
  end

  defp parse_topic(topic) when topic in @topic_hash_keys, do: @topic_hashes[topic]

  defp parse_topic(topic) do
    topic
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def parse_ecosystem_tools(_readme) do
    # TODO: Implement this function
    # Currently, it returns a hardcoded list of tools.
    [
      %{
        name: "The Web",
        items: [
          %{
            name: "Phoenix Framework",
            description:
              "Phoenix is a popular web development framework for building web applications with Elixir. Server-side rendering and real-time communication, are some of its key features. Has LiveView built-in, allowing developers to build interactive, real-time applications while writing little to no JavaScript.",
            thumbnail: true,
            url: "https://hexdocs.pm/phoenix/overview.html"
          },
          %{
            name: "Phoenix LiveView",
            description:
              "LiveView is a library that enables rich, real-time user experiences with server-rendered HTML. It allows developers to build interactive, real-time applications while writing little to no JavaScript.",
            thumbnail: false,
            url: "https://hexdocs.pm/phoenix_live_view/welcome.html"
          },
          %{
            name: "SurfaceUI",
            description:
              "A server-side rendering component library that allows developers to build rich interactive user-interfaces, writing minimal custom Javascript.",
            thumbnail: true,
            url: "https://hexdocs.pm/surface/Surface.html"
          },
          %{
            name: "LiveState",
            description:
              "The goal of LiveState is to make highly interactive web applications easier to build. Currently, in most such applications, clients send requests and receive responses from and to a server API. This essentially results in two applications, with state being managed in both in an ad hoc way.\n\nLiveState uses a different approach. Clients dispatch events, which are sent to the server to be handled, and receive updates from the server any time application state changes. This allows state to have a single source of truth, and greatly reduces client code complexity. It also works equally well for applications where updates to state can occur independently from a user initiated, client side event (think \"real time\" applications such as chat, etc).",
            thumbnail: false,
            url: "https://hexdocs.pm/live_state/readme.html"
          },
          %{
            name: "Plug",
            description:
              "A specification and composable modules for web application components, enabling HTTP request handling.",
            thumbnail: false,
            url: "https://hexdocs.pm/plug/readme.html"
          },
          %{
            name: "Absinthe",
            description:
              "A GraphQL toolkit for Elixir, an implementation of the GraphQL specification built to suit the language's capabilities and idiomatic style",
            thumbnail: true,
            url: "https://hexdocs.pm/absinthe/overview.html"
          }
        ]
      }
    ]
  end
end
