defmodule ZenSoft.MacroTest do

  import Tracer
  import Macros
  require MacroClient

  use ExUnit.Case
  use ShouldI

  test "tracer" do
    assert trace(1 + 2) == 3
  end

  test "create_ok_method" do
    assert MacroClient.my_method() == "ok"
  end

  create_test_method "My dynamically generated test" do
    assert 1 == 1
  end

  create_test_with_binding "Binding" do
    assert binding == :binding
  end

  # simple_list = [1, 2]

  # test_iterate_over_data "Data iteration", simple_list do
  #   assert 1 == 1
  # end


  test_with_data "My data driven test", 
  [
    %{a: 1, b: 1},
    %{a: 2, b: 2},
  ] do 
    assert tc == :test
    IO.puts inspect(sample)
  end

end
