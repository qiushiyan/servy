defmodule Servy.ServicesSupervisor do
  use Supervisor

  @name :services_supervisor
  def start_link(_arg) do
    IO.puts("starting the service")
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      Servy.PledgeServer,
      Servy.SensorServer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
