defmodule Turnstile do
  use GenServer

  # Client API

  def start_link do
    GenServer.start_link(__MODULE__, 0)
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

  def handle_call(:is_locked?, _from, tokens) do
    {:reply, locked?(tokens), tokens}
  end

  def handle_cast(:insert_coin, tokens),
    do: {:noreply, (tokens + 1)}

  def handle_call(:push, _from, 0),
    do: {:reply, {:error, "locked"}, 0}

  def handle_call(:push, _from, tokens),
    do: {:reply, :ok, (tokens - 1)}

  defp locked?(tokens) when tokens  == 0, do: true
  defp locked?(tokens) when tokens > 0, do: false
end
