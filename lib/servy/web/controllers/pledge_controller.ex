defmodule Servy.Web.Controllers.PledgeController do
  alias Servy.Web.Conv
  alias Servy.PledgeServer

  def index(conv) do
    pledges = PledgeServer.recent_pledges()
    %{conv | status: 200, res_body: inspect(pledges)}
  end

  def create(conv, %{"name" => name, "amount" => amount}) do
    PledgeServer.create_pledge(name, String.to_integer(amount))

    %Conv{conv | status: 201, res_body: "#{name} pledged #{amount}"}
  end
end
