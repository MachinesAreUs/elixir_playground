defmodule KV.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link __MODULE__, :ok
  end

  @manager_name           KV.EventManager
  @registry_name          KV.Registry
  @bucket_supervisor_name KV.Bucket.Supervisor
  @logger_name            KV.LogForwarder

  def init(:ok) do
    children = [
      worker(GenEvent,                 [[name: @manager_name]]),
      supervisor(KV.Bucket.Supervisor, [[name: @bucket_supervisor_name]]),
      worker(KV.Registry,              [@manager_name, @bucket_supervisor_name, [name: @registry_name]]),
      worker(KV.LogForwarder,          [[name: @logger_name]])
    ]

    supervise children, strategy: :one_for_one
  end
end
