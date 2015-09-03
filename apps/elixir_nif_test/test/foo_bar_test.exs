defmodule FooBarTest do
  use ExUnit.Case, async: true

  test "Foo should work" do
    assert FooBar.foo(5) == 10
  end

  test "Bar should work" do
    assert FooBar.bar(5) == 25
  end
end
