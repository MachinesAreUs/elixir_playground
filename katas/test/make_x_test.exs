defmodule ZenSoft.KatasTest do
  use ExUnit.Case
  import ZenSoft.Katas.MakeX

  test "size 1" do
    assert make_x(1) == [['x']]
  end

  test "size 2" do
    assert make_x(2) == [['x','x'],
                         ['x','x']]
  end

  test "size 3" do
    assert make_x(3) == [['x',' ','x'],
                         [' ','x',' '],
                         ['x',' ','x']]
  end

  test "size 4" do
    assert make_x(4) == [['x',' ',' ','x'],
                         [' ','x','x',' '],
                         [' ','x','x',' '],
                         ['x',' ',' ','x']]
  end

  test "size 5" do
    assert make_x(5) == [['x',' ',' ',' ','x'],
                         [' ','x',' ','x',' '],
                         [' ',' ','x',' ',' '],
                         [' ','x',' ','x',' '],
                         ['x',' ',' ',' ','x']]
  end

  test "size 5 as strings" do
    assert make_x_str(5) == ["x   x",
    						 " x x ",
                             "  x  ",
                             " x x ",
                             "x   x"]
  end

end
