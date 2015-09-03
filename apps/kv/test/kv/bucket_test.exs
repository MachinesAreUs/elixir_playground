defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KV.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "A new KV has no stored key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil
    assert KV.Bucket.get(bucket, "cow") == nil
    assert KV.Bucket.get(bucket, 1) == nil
    assert KV.Bucket.get(bucket, 2) == nil
  end

  test "stores the values by key", %{bucket: bucket} do
    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "deletes the values by key", %{bucket: bucket} do
    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
    assert KV.Bucket.delete(bucket, "milk") == 3
    assert KV.Bucket.delete(bucket, "milk") == nil
  end

end
