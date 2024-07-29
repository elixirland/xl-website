defmodule XlWebsite.Parser do
  @topic_hash_map %{
    "api" => "API",
    "postgresql" => "PostgreSQL"
  }
  @topic_hash_keys Map.keys(@topic_hash_map)
  @repo_prefix "xle-"
  @markdown_heading_regex ~r/(#+ .+?)(\n)+/

  def parse_body_params(conn, _opts \\ []) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    {:ok, body, Plug.Conn.put_private(conn, :raw_body, body)}
  end

  def filter_readme_sections(readme, headings) when is_list(headings) do
    readme
    |> group_markdown_by_headings()
    |> Enum.filter(&first_item_in_headings?(&1, headings))
    |> List.flatten()
    |> Enum.join()
  end

  defp group_markdown_by_headings(markdown) do
    @markdown_heading_regex
    |> Regex.split(markdown, include_captures: true, trim: true)
    |> Enum.reverse()
    |> Enum.reduce([], fn item, acc ->
      case String.starts_with?(item, "#") do
        true -> [[item] | acc]
        false -> List.replace_at(acc, 0, [item | List.first(acc)])
      end
    end)
    |> Enum.map(&Enum.reverse/1)
  end

  defp first_item_in_headings?([heading | _], headings) do
    heading_name_only =
      heading
      |> String.replace(~r/^#+ /, "")
      |> String.trim()

    String.contains?(heading_name_only, headings)
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
