defmodule XlWebsite.Parser do
  alias XlWebsite.Challenge

  @challenge_repo_prefix "xlc-"
  @topic_hash_map %{
    "api" => "API",
    "postgresql" => "PostgreSQL"
  }
  @topic_hash_keys Map.keys(@topic_hash_map)

  def normalize_repos(repos) do
    repos
    |> filter_challenge_repos()
    |> build_challenge_structs()
    |> Enum.sort_by(& &1.created_at, :desc)
  end

  defp build_challenge_structs(repos) do
    Enum.map(repos, fn repo ->
      %Challenge{
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

  defp filter_challenge_repos(repos) do
    repos
    |> Enum.filter(fn repo ->
      String.starts_with?(
        repo["name"],
        @challenge_repo_prefix
      )
    end)
  end

  defp parse_name(name) do
    name
    |> String.replace_prefix(@challenge_repo_prefix, "")
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
