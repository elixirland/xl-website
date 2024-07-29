defmodule XlWebsite.MarkdownParserTest do
  use ExUnit.Case
  alias XlWebsite.MarkdownParser

  describe "filter_readme_sections/2" do
    test "filters out sections not in list of headings" do
      markdown = """
      # Some Exercise Name
      Text A.

      ## Status
      Text B.

        - List of B.

      > [!NOTE]
      > Note of B.

      ## Introduction
      Text C.

      ## Task
      Text D.

      ## Requirements
      ### Some heading
      Text E.

        - List of E.

      > [!TIP]
      > Tip of E.

      ## How to get started
      Text F.

      ## Example solution
      Text g.
      """

      headings = ["Introduction", "Task", "Requirements", "Example solution"]

      assert MarkdownParser.filter_readme_sections(markdown, headings) ==
        """
        ## Introduction
        Text C.

        ## Task
        Text D.

        ## Requirements
        ### Some heading
        Text E.

          - List of E.

        > [!TIP]
        > Tip of E.

        ## Example solution
        Text g.
        """
    end
  end
end
