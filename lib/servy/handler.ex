defmodule Servy.Handler do
  alias Servy.Plugins
  alias Servy.Parsers
  alias Servy.Conv
  alias Servy.Controllers.BearController

  @moduledoc "handle http requests"
  @pages_path Path.expand("../../pages", __DIR__)
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
    %Conv{conv | res_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears", params: params} = conv) do
    BearController.create(conv, params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{path: path, method: method} = conv) do
    %Conv{conv | status: 404, res_body: "no #{method} #{path}"}
  end

  def handle_file({:ok, content}, %Conv{} = conv) do
    %Conv{conv | res_body: content}
  end

  def handle_file({:error, :enoent}, %Conv{} = conv) do
    %Conv{conv | res_body: "file not found"}
  end

  def handle_file({:error, reason}, %Conv{} = conv) do
    %Conv{conv | res_body: "file not found #{reason}"}
  end

  def format_response(%Conv{} = conv) do
    res_body = conv.res_body
    content_length = String.length(res_body)

    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{content_length}

    #{res_body}
    """
  end
end

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded

name=qiushi&age=18&type=largebear
"""

response = Servy.Handler.handle(request)

IO.puts(response)
