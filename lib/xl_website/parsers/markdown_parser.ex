defmodule XlWebsite.MarkdownParser do
  @md_heading_regex ~r/(?<!\\)(#+.+?)(\n)+/

  def filter_readme_sections(readme, headings) when is_list(headings) do
    readme
    |> group_by_headings()
    |> Enum.filter(&first_item_contains?(&1, headings))
    |> List.flatten()
    |> Enum.join()
  end

  defp group_by_headings(markdown) do
    parts =
      Regex.split(
        @md_heading_regex,
        markdown,
        include_captures: true,
        trim: true
      )

    parts
    |> Enum.reduce([], fn part, acc ->
      cond do
        level_2_heading?(part) -> [[part] | acc]
        level_1_heading?(part) -> acc
        acc == [] -> [[part] | acc]
        true -> List.update_at(acc, 0, &[part | &1])
      end
    end)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.reverse()
  end

  defp level_2_heading?(heading) do
    String.starts_with?(heading, "##") and
      not String.starts_with?(heading, "###")
  end

  defp level_1_heading?(heading) do
    String.starts_with?(heading, "#") and
      not String.starts_with?(heading, "##")
  end

  defp first_item_contains?([heading | _], headings) do
    heading_name_only =
      heading
      |> String.replace(~r/^#+/, "")
      |> String.trim()

    heading_name_only in headings
  end
end
