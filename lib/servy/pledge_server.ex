defmodule Servy.PledgeServer do
  use GenServer
  @name :pledge_server
  def start_link(_arg) do
    IO.puts("starting pledge server ...")
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  @impl true
  def init(args) do
    {:ok, args}
  end

  def recent_pledges() do
    GenServer.call(@name, :recent_pledges)
  end

  def create_pledge(name, amount) do
    GenServer.call(@name, {:create_pledge, name, amount})
  end

  def total_pledges() do
    GenServer.call(@name, :total_pledges)
  end

  def clear() do
    GenServer.cast(@name, :clear)
  end

  @impl true
  def handle_call({:create_pledge, name, amount}, _from, state) do
    recent_pledges = Enum.take(state, 2)
    new_state = [{name, amount} | recent_pledges]
    {:reply, {name, amount}, new_state}
  end

  @impl true
  def handle_call(:recent_pledges, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:total_pledges, _from, state) do
    total = state |> Enum.map(&elem(&1, 1)) |> Enum.sum()
    {:reply, total, state}
  end

  @impl true
  def handle_cast(:clear, _state) do
    {:noreply, []}
  end
end
