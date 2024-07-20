defmodule XlWebsite.Parser do
  alias XlWebsite.Exercise

  @exercise_repo_prefix "xle-"
  @topic_hash_map %{
    "api" => "API",
    "postgresql" => "PostgreSQL"
  }
  @topic_hash_keys Map.keys(@topic_hash_map)

  def filter_description(readme) do
    readme
    # TODO: Refactor this to use a regex for reliability
    |> String.split("\n\n## ")
    |> Enum.filter(fn section ->
      String.starts_with?(section, "Description")
    end)
    # TODO: Handle the case where there is no valid description heading
    |> hd()
    |> String.replace("Description\n", "")
  end

  def slug_to_name(slug) do
    slug
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def normalize_repos(repos) do
    repos
    |> filter_exercise_repos()
    |> build_exercise_structs()
    |> Enum.sort_by(& &1.created_at, :desc)
  end

  defp build_exercise_structs(repos) do
    Enum.map(repos, fn repo ->
      %Exercise{
        slug: build_slug(repo["name"]),
        name: parse_name(repo["name"]),
        description: repo["description"],
        full_name: repo["full_name"],
        html_url: repo["html_url"],
        created_at: repo["created_at"],
        updated_at: repo["updated_at"],
        visibility: repo["visibility"],
        topics: parse_topics(repo["topics"])
      }
    end)
  end

  defp filter_exercise_repos(repos) do
    repos
    |> Enum.filter(fn repo ->
      String.starts_with?(
        repo["name"],
        @exercise_repo_prefix
      )
    end)
  end

  defp build_slug(name) do
    name
    |> String.replace_prefix(@exercise_repo_prefix, "")
    |> String.downcase()
    |> String.replace(" ", "-")
  end

  defp parse_name(name) do
    name
    |> String.replace_prefix(@exercise_repo_prefix, "")
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  defp parse_topics(topics) do
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
