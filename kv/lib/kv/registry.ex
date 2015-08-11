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
    names = Map.new
    refs  = Map.new
    {:ok, {names, refs}} 
  end

  def handle_call(:stop, _from, names) do
    IO.puts Colorful.string("terminating server", [:blue])
    {:stop, :normal, :ok, names}
  end

  def handle_call({:lookup, name}, _from, {names, _} = state) do
    {:reply, Map.fetch(names, name), state}
  end

  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      {:ok, bucket} = KV.Bucket.start_link()
      ref = Process.monitor bucket
      refs = Map.put refs, ref, name
      names = Map.put names, name, bucket
      {:noreply, {names, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(msg, state) do
    IO.puts Colorful.string("received message #{inspect msg}", [:blue])
    {:noreply, state}
  end

end
