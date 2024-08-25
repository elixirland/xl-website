defmodule XlWebsite.ParamParserTest do
  use ExUnit.Case
  alias XlWebsite.ParamParser

  describe "parse_topics/1" do
    test "returns topics with correct casing" do
      topics = ["api", "postgresql", "elixir", "phoenix", "mix"]

      assert ParamParser.parse_topics(topics) == ["API", "PostgreSQL", "Elixir", "Phoenix", "Mix"]
    end

    test "returns topics with correct spaces and dashes" do
      topics = ["web-services", "some-other-topic"]

      assert ParamParser.parse_topics(topics) == ["Web Services", "Some Other Topic"]
    end
  end

  describe "build_name/2" do
    test "returns correct name" do
      full_name = "elixirland/xlp-book-club-API"

      assert ParamParser.build_name(full_name) == "Book Club API"
    end
  end
end
