defmodule Servy.Fetcher do
  def async(f) do
    parent = self()

    spawn(fn ->
      send(parent, {self(), :result, f.()})
    end)
  end

  def await(pid) do
    receive do
      {^pid, :result, res} -> res
    end
  end
end
