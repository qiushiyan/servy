defmodule Servy.KickStarter do
  use GenServer
  @name :kick_starter
  def start_link(_arg) do
    IO.puts("starting KickStarter ...")
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    # don't let http server process crash kickstarter process
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  def handle_info({:EXIT, _pid, _reason}, _state) do
    server_pid = start_server()
    {:noreply, server_pid}
  end

  defp start_server() do
    IO.puts("starting http server ...")
    server_pid = spawn_link(Servy.Web.HttpServer, :start, [4000])
    Process.register(server_pid, :http_server)
    server_pid
  end
end
