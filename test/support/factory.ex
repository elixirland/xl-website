defmodule XlWebsite.Factory do
  alias XlWebsite.Repo
  alias XlWebsite.Exercises.Exercise
  alias XlWebsite.Ecosystem

  def insert!(name, attrs \\ []) do
    name
    |> build(attrs)
    |> Repo.insert!()
  end

  defp build(name, attrs) do
    name
    |> build_default()
    |> struct!(attrs)
  end

  defp build_default(:exercise) do
    %Exercise{
      full_name: "elixirland/xle-book-club",
      name: "Book Club",
      slug: "book-club",
      topics: ["Elixir", "OTP"],
      readme: readme()
    }
  end

  defp build_default(:category) do
    %Ecosystem.Category{
      name: "The Web"
    }
  end

  defp build_default(:tool) do
    %Ecosystem.Tool{
      name: "Some tool",
      description: "Some description",
      category_id: nil
    }
  end

  defp readme() do
    """
    # Some Exercise Name
    Some text.

    ## Status
    Exercise: ***Not Reviewed***<br>
    Solution: ***Not Reviewed***

    > [!NOTE]
    > Some note.

    ## Introduction
    Some text.

    ## Task description
    Some text.

    ## Requirements
    ### Some heading
      - Some list.

    > [!TIP]
    > Some tip.

    ## How to get started
    Some text.

    ## Example solution
    Some text.
    """
  end
end
