defmodule Servy.KickStarter do
  @name __MODULE__
  def start() do
    IO.puts("starting KickStarter ...")
    GenServer.start(@name, :ok, name: @name)
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
    server_pid = spawn_link(Servy.HttpServer, :start, [4000])
    Process.register(server_pid, :http_server)
    server_pid
  end
end
