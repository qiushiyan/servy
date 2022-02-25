defmodule Servy.Helpers do
  def render(path, bindings \\ []) do
    path |> EEx.eval_file(bindings)
  end
end
