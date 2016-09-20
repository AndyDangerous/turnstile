defmodule Turnstile do
  use GenServer

  # Client API

  def start_link do
    GenServer.start_link(__MODULE__, {:locked, 0})
  end

  def is_locked?(pid) do
    GenServer.call(pid, :is_locked?)
  end

  def insert_coin(pid) do
    GenServer.cast(pid, :insert_coin)
  end

  def push(pid) do
    GenServer.call(pid, :push)
  end

  # Server Callbacks

  def handle_call(:is_locked?, _from, {:unlocked, _tokens} = state),
    do: {:reply, false, state}

  def handle_call(:is_locked?, _from, {:locked, _tokens} = state),
    do: {:reply, true, state}

  def handle_cast(:insert_coin, {_locked_state, tokens}),
    do: {:noreply, {:unlocked, (tokens + 1)}}

  def handle_call(:push, _from, {:unlocked, tokens}),
    do: {:reply, :ok, new_state(tokens - 1)}

  def handle_call(:push, _from, {:locked, 0}),
    do: {:reply, {:error, "locked"}, {:locked, 0}}

  defp new_state(0), do: {:locked, 0}
  defp new_state(tokens), do: {:unlocked, tokens}
end
