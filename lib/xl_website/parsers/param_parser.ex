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
end
