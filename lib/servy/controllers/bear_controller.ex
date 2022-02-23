defmodule Servy.Controllers.BearController do
  alias Servy.Conv
  alias Servy.Wildthings
  alias Servy.Bear

  @templates_path Path.expand("../../../templates", __DIR__)
  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.compare_name/2)

    content = render("index.eex", bears: bears)
    %Conv{conv | res_body: content}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    content = render("show.eex", bear: bear)
    %Conv{conv | res_body: content}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %Conv{conv | status: 201, res_body: "created bear #{name} of #{type}"}
  end

  defp render(file, bindings \\ []) do
    @templates_path |> Path.join(file) |> EEx.eval_file(bindings)
  end
end
