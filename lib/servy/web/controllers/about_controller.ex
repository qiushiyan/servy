defmodule Servy.Web.Controllers.AboutController do
  alias Servy.Web.Conv
  @pages_path Path.expand("../../../../pages", __DIR__)
  def index(conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def handle_file({:ok, content}, conv) do
    %Conv{conv | res_body: content, status: 200}
  end

  def handle_file({:error, :enoent}, conv) do
    %Conv{conv | res_body: "file not found", status: 404}
  end

  def handle_file({:error, reason}, conv) do
    %Conv{conv | res_body: "file not found #{reason}", status: 500}
  end
end
