defmodule GenEventTest do
  use ExUnit.Case, async: true

  test "consume events as streams" do
    {:ok, manager} = GenEvent.start_link
    this = self()
    spawn_link fn ->
      for msg <- GenEvent.stream(manager) do
        IO.inspect msg
        Process.send(this, msg, [])
      end
    end
    GenEvent.notify manager, {:ok, "message"}
    assert_receive {:ok, "message"} #, 200
  end
end
