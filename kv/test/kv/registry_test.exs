defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = KV.Registry.start_link
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

end
