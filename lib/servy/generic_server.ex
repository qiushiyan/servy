defmodule Servy.GenericServer do
  def start(callback_module, initial_state, name) do
    pid =
      spawn(fn ->
        listen_loop(callback_module, initial_state)
      end)

    Process.register(pid, name)
    pid
  end

  def call(pid, request) do
    send(pid, {:call, self(), request})

    receive do
      {:response, response} ->
        response
    end
  end

  def cast(pid, request) do
    send(pid, {:cast, request})
  end

  def listen_loop(callback_module, state \\ []) do
    receive do
      {:call, sender, request} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(request, state)
        send(sender, {:response, response})
        listen_loop(callback_module, new_state)

      {:cast, request} ->
        new_state = callback_module.handle_cast(request, state)
        listen_loop(callback_module, new_state)

      unexpected ->
        IO.puts("unexpected message: #{unexpected}")
        listen_loop(callback_module, state)
    end
  end
end
