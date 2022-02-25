defmodule Servy.Web.Controllers.BearApiController do
  alias Servy.Web.Wildthings

  def index(conv) do
    json = Wildthings.list_bears() |> Poison.encode!()

    %{conv | status: 200, res_body: json, res_content_type: "application/json"}
  end
end
