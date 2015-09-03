defmodule KV.LogForwarder do
  use GenServer
  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link __MODULE__, :ok, opts
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_cast({:log, msg}, _state) do
    Logger.debug (inspect msg)
    {:noreply, _state} 
  end
end
