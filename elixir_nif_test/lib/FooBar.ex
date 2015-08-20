defmodule FooBar do
  @on_load{:init, 0}

  def init do
    :ok = :erlang.load_nif('src/foobar_nif', 0)
  end

  def foo(_) do end
  def bar(_) do end
end
