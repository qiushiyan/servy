defmodule Servy.ServicesSupervisor do
  use Supervisor

  @name __MODULE__
  def start_link do
    IO.puts("starting the service")
    Supervisor.start_link(@name, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      Servy.PledgeServer,
      Servy.SensorServer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
