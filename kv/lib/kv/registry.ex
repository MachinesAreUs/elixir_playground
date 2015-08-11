defmodule KV.Registry do
  use GenServer

  # Client API

  def start_link(opts \\ []) do
    GenServer.start_link __MODULE__, :ok, opts
  end

  def stop(server) do
    GenServer.call server, :stop
  end

  def lookup(server, name) do
    GenServer.call server, {:lookup, name}
  end

  def create(server, name) do
    GenServer.cast server, {:create, name}
  end

  # Server Callbacks

  def init(:ok) do
    {:ok, Map.new} 
  end

  def handle_call(:stop, _from, names) do
    IO.puts Colorful.string("terminating server", [:blue])
    {:stop, :normal, :ok, names}
  end

  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  def handle_cast({:create, name}, names) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      {:ok, bucket} = KV.Bucket.start_link()
      {:noreply, Map.put(names, name, bucket)}
    end
  end

end
