defmodule Servy.Parsers do
  alias Servy.Conv

  def parse(request) do
    [top | param_string] = String.split(request, "\r\n\r\n")

    [request_line | header_lines] = String.split(top, "\r\n")

    headers = parse_headers(header_lines, %{})
    [method, path, _] = String.split(request_line, " ")

    params = parse_params(param_string, headers["Content-Type"])
    %Conv{method: method, path: path, params: params, headers: headers}
  end

  @doc """
  Parses the given param string of the form `key1=value1&key2=value2`
  into a map with corresponding keys and values.

  ## Examples
      iex> params_string = ["name=Baloo&type=Brown"]
      iex> Servy.Parsers.parse_params(params_string, "application/x-www-form-urlencoded")
      %{"name" => "Baloo", "type" => "Brown"}
      iex> Servy.Parsers.parse_params(params_string, "multipart/form-data")
      %{}
  """
  def parse_params([h | _], "application/x-www-form-urlencoded") do
    h |> String.trim() |> URI.decode_query()
  end

  def parse_params(_, _content_type), do: %{}

  def parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")

    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers
end
