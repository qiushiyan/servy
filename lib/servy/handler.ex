defmodule Servy.Handler do
  alias Servy.Plugins
  alias Servy.Parsers
  alias Servy.Conv
  alias Servy.Controllers.BearController
  alias Servy.Controllers.BearApiController
  alias Servy.Controllers.AboutController

  @moduledoc "handle http requests"

  def handle(request) do
    request
    |> Parsers.parse()
    |> Plugins.rewrite_path()
    |> route
    |> Plugins.track()
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    # TODO: Create a new map that also has the response body:
    %Conv{conv | status: 200, res_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    BearApiController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears", params: params} = conv) do
    BearController.create(conv, params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    AboutController.index(conv)
  end

  def route(%Conv{path: path, method: method} = conv) do
    %Conv{conv | status: 404, res_body: "no #{method} #{path}"}
  end

  def format_response(%Conv{} = conv) do
    res_body = conv.res_body
    res_content_type = conv.res_content_type
    content_length = String.length(res_body)

    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{res_content_type}\r
    Content-Length: #{content_length}\r
    \r
    #{res_body}
    """
  end
end
