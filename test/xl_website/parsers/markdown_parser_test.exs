defmodule XlWebsite.MarkdownParserTest do
  use ExUnit.Case
  alias XlWebsite.MarkdownParser

  describe "filter_h2_headings/2" do
    test "removes the sections contained a list of headings" do
      headings = ["Heading A", "Heading B"]

      markdown =
        """
        # Title

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

      assert MarkdownParser.filter_h2_headings(markdown, reject: headings) ==
               """
               ## Heading C
               Text C.

               ## Heading D
               Text D.
               """
    end

    test "also works when there is no space between hash character and heading text" do
      headings = ["Heading A", "Heading C"]

      markdown =
        """
        #Title

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

      assert MarkdownParser.filter_h2_headings(markdown, reject: headings) ==
               """
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

      assert MarkdownParser.filter_h2_headings(markdown, reject: headings) ==
               """
               ## heading a
               Text

               ### heading B
               Text
               """
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

      assert MarkdownParser.filter_h2_headings(markdown, reject: headings) ==
               """
               ## Heading AA
               Text
               """
    end

    test "handles escaped hash characters" do
      headings = ["Heading A", "Heading B"]
      markdown = ~s|\###\# Heading A\nThis is a hash character: \#\n## Heading B\nText|

      assert MarkdownParser.filter_h2_headings(markdown, reject: headings) == ""
    end
  end

  describe "parse_ecosystem_tools/1" do
    test "returns correct list of tools" do
      markdown =
        """
        # The Elixir Ecosystem

        Some text about the Elixir ecosystem.

        ## The Web

        ### Phoenix Framework

        Some text about Phoenix.

        [Documentation](https://phoenix.test)

        ### Phoenix LiveView

        Some text about LiveView.

        [Documentation](https://liveview.test)

        ## Native Applications

        ### Scenic

        Some text about Scenic.

        [Documentation](https://scenic.test)

        ### LiveView Native

        Some text about LiveView Native.

        [Documentation](https://liveviewnative.test)
        """

      expected = [
        %{
          name: "Native Applications",
          tools: [
            %{
              name: "LiveView Native",
              description:
                "Some text about LiveView Native.\n\n[Documentation](https://liveviewnative.test)"
            },
            %{
              name: "Scenic",
              description: "Some text about Scenic.\n\n[Documentation](https://scenic.test)"
            }
          ]
        },
        %{
          name: "The Web",
          tools: [
            %{
              name: "Phoenix LiveView",
              description: "Some text about LiveView.\n\n[Documentation](https://liveview.test)"
            },
            %{
              name: "Phoenix Framework",
              description: "Some text about Phoenix.\n\n[Documentation](https://phoenix.test)"
            }
          ]
        }
      ]

      assert MarkdownParser.parse_ecosystem_tools(markdown) == expected
    end
  end
end
