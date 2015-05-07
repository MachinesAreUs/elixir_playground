defmodule ZenSoft.KatasTest do
  use ExUnit.Case
  import ZenSoft.Katas.MakeX

  test "make_x 1" do
    assert make_x(1) == [['x']]
  end

  test "make_x 2" do
    assert make_x(2) == [['x','x'],
                         ['x','x']]
  end

  test "make_x 3" do
    assert make_x(3) == [['x',' ','x'],
                         [' ','x',' '],
                         ['x',' ','x']]
  end

  test "make_x 4" do
    assert make_x(4) == [['x',' ',' ','x'],
                         [' ','x','x',' '],
                         [' ','x','x',' '],
                         ['x',' ',' ','x']]
  end

  test "make_x 5" do
    assert make_x(5) == [['x',' ',' ',' ','x'],
                         [' ','x',' ','x',' '],
                         [' ',' ','x',' ',' '],
                         [' ','x',' ','x',' '],
                         ['x',' ',' ',' ','x']]
  end

  test "make_x_str 3" do
    assert make_x_str(3) == ["x x",
                             " x ",
                             "x x"]
  end

end
