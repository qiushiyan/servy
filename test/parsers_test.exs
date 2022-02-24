defmodule ParsersTest do
  use ExUnit.Case
  doctest Servy.Parsers

  alias Servy.Parsers

  test "parses a list of header fields into a map" do
    header_lines = ["A: 1", "B: 1"]
    headers = Parsers.parse_headers(header_lines, %{})
    assert headers == %{"A" => "1", "B" => "1"}
  end
end
