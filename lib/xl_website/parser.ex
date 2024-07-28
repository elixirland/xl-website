defmodule XlWebsite.Parser do
  @topic_hash_map %{
    "api" => "API",
    "postgresql" => "PostgreSQL"
  }
  @topic_hash_keys Map.keys(@topic_hash_map)
  @repo_prefix "xle-"

  def parse_body_params(conn, _opts \\ []) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    conn = Plug.Conn.put_private(conn, :raw_body, body)
    {:ok, body, conn}
  end

  def filter_description(readme) do
    readme =
      readme
      # TODO: Refactor this to use a regex for reliability
      |> String.split("\n\n## ")
      |> Enum.drop(2)
      |> Enum.reverse()
      |> Enum.drop(1)
      |> Enum.reverse()
      |> Enum.join("\n\n## ")

    "\n\n## " <> readme
  end

  def build_name(full_name) do
    full_name
    |> String.split("/")
    |> List.last()
    |> String.replace(@repo_prefix, "")
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
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

  defp parse_topic(topic) when topic in @topic_hash_keys do
    @topic_hash_map[topic]
  end

  defp parse_topic(topic) do
    String.capitalize(topic)
  end
end
