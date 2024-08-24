defmodule XlWebsite.MarkdownParser do
  @md_heading_regex ~r/(?<!\\)(#+.+?)(\n)+/

  @one_or_many_hashes ~r/#+/
  @one_or_many_new_lines ~r/\n+/
  @starts_with_one_hash ~r/^#(?!#)/
  @starts_with_two_hashes ~r/^##(?!#)/
  @starts_with_one_or_many_hashes ~r/^#+/

  def filter_readme_sections(readme, headings) when is_list(headings) do
    readme
    |> group_by_headings()
    |> Enum.filter(&first_item_contains?(&1, headings))
    |> List.flatten()
    |> Enum.join()
  end

  @doc """
  Extracts the heading sections from the markdown and returns a list of
  categories with their tools.

  ## Returns
  Return a list of with a map for each category containing the category name and
  a list of tools. Each tool is a map with a name and a description, with the
  description formatted as raw Markdown syntax.
  """
  def parse_ecosystem_tools(markdown) do
    markdown
    |> extract_sections()
    |> reject_h1_sections()
    |> sections_to_attrs_list()
  end

  # Private functions

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
      |> String.replace(@starts_with_one_or_many_hashes, "")
      |> String.trim()

    heading_name_only in headings
  end

  defp extract_sections(markdown) do
    opts = [include_captures: true, trim: true]

    @one_or_many_hashes
    |> Regex.split(markdown, opts)
    |> Enum.reduce([], fn part, acc ->
      if part =~ @one_or_many_hashes,
        # If part is a heading, treat it as a new section
        do: [[part] | acc],
        # Else, concatenate the part with the last section
        else: List.update_at(acc, 0, &(hd(&1) <> part))
    end)
    |> Enum.reverse()
    |> Enum.map(&String.replace_trailing(&1, "\n", ""))
  end

  defp reject_h1_sections(parts) do
    Enum.reject(parts, &String.match?(&1, @starts_with_one_hash))
  end

  defp sections_to_attrs_list(sections) do
    sections
    |> Enum.map(&split_heading_from_body/1)
    |> Enum.reduce([], fn [heading | rest], acc ->
      if String.match?(heading, @starts_with_two_hashes) do
        # If heading starts with two hashes, treat it as a category
        category = %{name: parse_heading(heading), tools: []}
        [category | acc]
      else
        # Else, treat it as a tool under the last category
        body = List.last(rest)

        List.update_at(acc, 0, fn category ->
          Map.update(category, :tools, [], fn tools ->
            # Add the tool to the existing list of tools in the category
            tool = %{name: parse_heading(heading), description: body}
            [tool | tools]
          end)
        end)
      end
    end)
  end

  defp split_heading_from_body(section) do
    String.split(section, @one_or_many_new_lines, parts: 2)
  end

  defp parse_heading(heading) do
    heading
    |> String.replace(@starts_with_one_or_many_hashes, "")
    |> String.trim()
  end
end
