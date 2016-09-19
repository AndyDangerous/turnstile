defmodule Turnstile do
  use GenServer

  # Client API

  def start_link do
    GenServer.start_link(__MODULE__, :locked)
  end

  def is_locked?(pid) do
    GenServer.call(pid, :is_locked?)
  end

  def insert_coin(pid) do
    GenServer.call(pid, :insert_coin)
  end

  def push(pid) do
    GenServer.call(pid, :push)
  end

  # Server Callbacks
  def handle_call(:is_locked?, _from, :unlocked = state) do
    {:reply, false, state}
  end
  def handle_call(:is_locked?, _from, :locked = state) do
    {:reply, true, state}
  end

  def handle_call(:insert_coin, _from, _state) do
    {:reply, :ok, :unlocked}
  end

  def handle_call(:push, _from, state) do
    case state do
      :unlocked -> lock!(:ok)
      :locked -> lock!({:error, "it's locked"})
    end
  end

  defp lock!(message) do
    {:reply, message, :locked}
  end
end
