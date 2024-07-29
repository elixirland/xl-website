defmodule XlWebsite.MarkdownParserTest do
  use ExUnit.Case
  alias XlWebsite.MarkdownParser

  describe "filter_readme_sections/2" do
    test "filters out sections not in list of headings" do
      headings = ["Heading A", "Heading B", "Heading D"]

      markdown =
        """
        # Title
        Title text.

        ## Heading A
        Text A.

        ## Heading B
        ### Subheading
        Text B.

          - List of B.

        > [!TIP]
        > Tip of B.

        ## Heading C
        Text C.

        ## Heading D
        Text D.
        """

      assert MarkdownParser.filter_readme_sections(markdown, headings) ==
               """
               ## Heading A
               Text A.

               ## Heading B
               ### Subheading
               Text B.

                 - List of B.

               > [!TIP]
               > Tip of B.

               ## Heading D
               Text D.
               """
    end

    test "allows no space between hash character heading text" do
      headings = ["Heading A", "Heading B", "Heading D"]

      markdown =
        """
        #Title
        Title text.

        ##Heading A
        Text A.

        ##Heading B
        ###Subheading
        Text B.

          - List of B.

        > [!TIP]
        > Tip of B.

        ##Heading C
        Text C.

        ##Heading D
        Text D.
        """

      assert MarkdownParser.filter_readme_sections(markdown, headings) ==
               """
               ##Heading A
               Text A.

               ##Heading B
               ###Subheading
               Text B.

                 - List of B.

               > [!TIP]
               > Tip of B.

               ##Heading D
               Text D.
               """
    end

    test "matches heading text with case-sensitivity" do
      headings = ["Heading A"]

      markdown =
        """
        ## heading a
        Text

        ### heading B
        Text
        """

      assert MarkdownParser.filter_readme_sections(markdown, headings) == ""
    end

    test "matches full heading text" do
      headings = ["Heading A"]

      markdown =
        """
        ## Heading A
        Text

        ## Heading AA
        Text
        """

      assert MarkdownParser.filter_readme_sections(markdown, headings) ==
               """
               ## Heading A
               Text

               """
    end

    test "handles escaped hash characters" do
      headings = ["Heading A", "Heading B"]
      markdown = ~s|\###\# Heading A\nThis is a hash character: \#\n## Heading B\nText|

      assert MarkdownParser.filter_readme_sections(markdown, headings) ==
               ~s|\###\# Heading A\nThis is a hash character: \#\n## Heading B\nText|
    end
  end
end
