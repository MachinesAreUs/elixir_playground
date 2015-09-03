defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  defmodule Forwarder do
    use GenEvent

    def handle_event(event, parent) do
      send parent, event
      {:ok, parent}
    end
  end

  setup do
    {:ok, bucket_supervisor} = KV.Bucket.Supervisor.start_link
    {:ok, manager} = GenEvent.start_link
    {:ok, registry} = KV.Registry.start_link manager, bucket_supervisor

    GenEvent.add_mon_handler manager, Forwarder, self()
    {:ok, registry: registry}
  end

  test "stops a registry", %{registry: registry} do
    assert KV.Registry.stop(registry) == :ok
  end

  test "spawns buckets", %{registry: registry} do
    assert KV.Registry.lookup(registry, "foo") == :error

    KV.Registry.create(registry, "foo")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "foo")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    KV.Registry.create(registry, "foo")
    {:ok, bucket} = KV.Registry.lookup(registry, "foo")
    Agent.stop(bucket)
    assert KV.Registry.lookup(registry, "foo") == :error
  end

  test "any other messsage is handled by 'handle_info", %{registry: registry} do
    Process.send registry, {self(), "some message"}, []
    assert_receive {:ok, "some message"} 
  end

  # Event management

  test "sends events on create and crash", %{registry: registry} do
    KV.Registry.create registry, "animals"
    {:ok, bucket} = KV.Registry.lookup registry, "animals"
    assert_receive {:create, "animals", ^bucket}

    Agent.stop bucket
    assert_receive {:exit, "animals", ^bucket}
  end

  # Fault tolerance

  test "removes bucket on crash", %{registry: registry} do
    KV.Registry.create registry, "animals"
    {:ok, bucket} = KV.Registry.lookup registry, "animals"

    Process.exit bucket, :shutdown
    assert_receive {:exit, "animals", ^bucket}
    assert KV.Registry.lookup registry, "animals" == :error
  end
end
