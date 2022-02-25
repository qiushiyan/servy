defmodule Servy.Web.Controllers.BearController do
  alias Servy.Web.Conv
  alias Servy.Web.Wildthings
  alias Servy.Web.Bear
  alias Servy.Helpers

  @templates_path Path.expand("../../../../templates/bears", __DIR__)
  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.compare_name/2)

    content = Helpers.render(Path.join(@templates_path, "index.eex"), bears: bears)
    %Conv{conv | res_body: content, status: 200}
  end

  def show(conv, %{"bear_id" => id}) do
    bear = Wildthings.get_bear(id)
    content = Helpers.render(Path.join(@templates_path, "show.eex"), bear: bear)
    %Conv{conv | res_body: content, status: 200}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %Conv{conv | status: 201, res_body: "created bear #{name} of #{type}"}
  end
end
