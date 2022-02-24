defmodule Servy.Controllers.BearApiController do
  def index(conv) do
    json = Servy.Wildthings.list_bears() |> Poison.encode!()

    %{conv | status: 200, res_body: json, res_content_type: "application/json"}
  end
end
