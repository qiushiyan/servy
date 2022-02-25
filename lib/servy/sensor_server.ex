defmodule Servy.SensorServer do
  use GenServer
  @name :sensor_server
  @refresh_interval :timer.seconds(3600)

  def start_link(_arg) do
    IO.puts("starting sensor server ...")
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def get_sensor_data() do
    GenServer.call(@name, :get_sensor_data)
  end

  @impl true
  def init(_state) do
    initial_state = query_sensor_data()
    schedule_refresh()
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:refresh, _state) do
    IO.puts("refreshing sensor images ...")
    new_state = query_sensor_data()
    schedule_refresh()
    {:noreply, new_state}
  end

  defp schedule_refresh() do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  defp query_sensor_data() do
    [1, 2, 3]
    |> Enum.map(&Task.async(fn -> get_snapshot(&1) end))
    |> Enum.map(&Task.await/1)
  end

  def get_snapshot(camera_name) do
    # CODE GOES HERE TO SEND A REQUEST TO THE EXTERNAL API

    # Sleep for 1 second to simulate that the API can be slow:
    :timer.sleep(1000)

    # Example response returned from the API:
    "#{camera_name}-snapshot-#{:rand.uniform(1000)}.jpg"
  end
end
