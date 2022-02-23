defmodule Servy.Parsers do
  alias Servy.Conv

  def parse(request) do
    [top, param_string] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    headers = parse_headers(header_lines, %{})
    [method, path, _] = String.split(request_line, " ")

    params = parse_params(param_string, headers["Content-Type"])
    %Conv{method: method, path: path, params: params, headers: headers}
  end

  defp parse_params(param_string, "application/x-www-form-urlencoded") do
    param_string |> String.trim() |> URI.decode_query()
  end

  defp parse_params(_, _content_type), do: %{}

  defp parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")

    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  defp parse_headers([], headers), do: headers
end
