defmodule Servy do
  readme_path = [__DIR__, "..", "README.md"] |> Path.join() |> Path.expand()

  @external_resource readme_path
  @moduledoc readme_path |> File.read!() |> String.trim()
  def hello do
    :world
  end
end
