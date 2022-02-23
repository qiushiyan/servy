defmodule Servy.Bear do
  defstruct id: nil, name: "", type: "", hibernating: false

  def is_type(bear, type) do
    bear.type == type
  end

  def compare_name(b1, b2) do
    b1.name <= b2.name
  end
end
