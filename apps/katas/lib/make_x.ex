defmodule ZenSoft.Katas.MakeX do

  def value(size, r, c) do
    if r == c or r == (size - c + 1) do 'x' else ' ' end
  end

  def make_x(size) do
    for r <- 1..size do
      for c <- 1..size, do: value(size, r, c)
    end
  end

  def make_x_str(size) do
    Enum.map make_x(size), &(to_string &1)
  end
end