defmodule Servy.PledgeServer do
  alias Servy.GenericServer
  @name __MODULE__
  def start() do
    pid = GenericServer.start(@name, [], @name)
    pid
  end

  def recent_pledges() do
    GenericServer.call(@name, :recent_pledges)
  end

  def create_pledge(name, amount) do
    GenericServer.call(@name, {:create_pledge, name, amount})
  end

  def total_pledges() do
    GenericServer.call(@name, :total_pledges)
  end

  def clear() do
    GenericServer.cast(@name, :clear)
  end

  def handle_call({:create_pledge, name, amount}, state) do
    recent_pledges = Enum.take(state, 2)
    new_state = [{name, amount} | recent_pledges]
    {{name, amount}, new_state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call(:total_pledges, state) do
    total = state |> Enum.map(&elem(&1, 1)) |> Enum.sum()
    {total, state}
  end

  def handle_call(_, state) do
    IO.puts("unsupported message")
    {nil, state}
  end

  def handle_cast(:clear, _state) do
    []
  end

  def handle_cast(_, state) do
    IO.puts("unsupported message")
    state
  end
end
