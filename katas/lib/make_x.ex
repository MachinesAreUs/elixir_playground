defmodule ZenSoft.Katas.MakeX do

  def value(size, r, c) do
    if r == c or r == (size - c + 1) do 'x' else ' ' end
  end

  def make_x(size) do
    for r <- 1..size do
      line = []
      line = for c <- 1..size do
        line ++ [value(size, r, c)]
      end
      line |> Enum.concat 
    end
  end

  def make_x_str(size) do
    mtx = make_x size
    Enum.map(mtx, fn(row) -> to_string row end)
  end
end