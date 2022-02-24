defmodule Servy.Plugins do
  alias Servy.Conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %Conv{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env() == :dev do
      IO.puts("Warning #{path} is on the loose")
    end

    conv
  end

  def track(%Conv{} = conv), do: conv
end
