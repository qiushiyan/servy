defmodule Servy do
  alias Servy.Supervisor
  readme_path = [__DIR__, "..", "README.md"] |> Path.join() |> Path.expand()

  @external_resource readme_path
  @moduledoc readme_path |> File.read!() |> String.trim()
  use Application

  def start(_type, _args) do
    IO.puts("starting application ...")
    Supervisor.start_link()
  end
end
