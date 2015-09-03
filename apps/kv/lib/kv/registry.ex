defmodule KV.Registry do
  use GenServer

  # Client API

  def start_link(event_manager, bucket_supervisor, opts \\ []) do
    GenServer.start_link __MODULE__, {event_manager, bucket_supervisor}, opts
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

  def init({events, bucket_supervisor}) do
    names = Map.new
    refs  = Map.new
    {:ok, %{names: names, refs: refs, events: events, buckets: bucket_supervisor}} 
  end

  def handle_call(:stop, _from, names) do
    #IO.puts Colorful.string("terminating server", [:blue])
    IO.puts "terminating server"
    {:stop, :normal, :ok, names}
  end

  def handle_call({:lookup, name}, _from, state) do
    {:reply, Map.fetch(state.names, name), state}
  end

  def handle_cast({:create, name}, state) do
    if Map.has_key?(state.names, name) do
      {:noreply, state}
    else
      #{:ok, bucket} = KV.Bucket.start_link()
      {:ok, bucket} = KV.Bucket.Supervisor.start_bucket state.buckets
      ref = Process.monitor bucket
      refs = Map.put state.refs, ref, name
      names = Map.put state.names, name, bucket

      GenEvent.sync_notify state.events, {:create, name, bucket}
      {:noreply, %{state | names: names, refs: refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, pid, _reason}, state) do
    {name, refs} = Map.pop(state.refs, ref)
    names = Map.delete(state.names, name)

    GenEvent.sync_notify state.events, {:exit, name, pid}
    {:noreply, %{state | names: names, refs: refs}}
  end

  def handle_info({pid, msg}, state) do
    Process.send pid, {:ok, msg}, []
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

end
