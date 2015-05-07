defmodule ZenSoft.Katas.MakeXTest do
  import ZenSoft.Katas.MakeX
  use ExUnit.Case
  use ShouldI

  should "return 1" do
    assert make_x(1) == [['x']]
  end

  should "size 2" do
    assert make_x(2) == [['x','x'],
                         ['x','x']]
  end

  should "size 3" do
    assert make_x(3) == [['x',' ','x'],
                         [' ','x',' '],
                         ['x',' ','x']]
  end

  should "size 4" do
    assert make_x(4) == [['x',' ',' ','x'],
                         [' ','x','x',' '],
                         [' ','x','x',' '],
                         ['x',' ',' ','x']]
  end

  should "size 5" do
    assert make_x(5) == [['x',' ',' ',' ','x'],
                         [' ','x',' ','x',' '],
                         [' ',' ','x',' ',' '],
                         [' ','x',' ','x',' '],
                         ['x',' ',' ',' ','x']]
  end

  should "size 5 as strings" do
    assert make_x_str(5) == ["x   x",
                             " x x ",
                             "  x  ",
                             " x x ",
                             "x   x"]
  end

end
