defmodule Servy.Supervisor do
  use Supervisor
  @name :top_supervisor
  def start_link do
    IO.puts("starting top-level supervisor ...")
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      Servy.KickStarter,
      Servy.ServicesSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
