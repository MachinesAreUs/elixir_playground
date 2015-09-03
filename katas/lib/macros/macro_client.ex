defmodule MacroClient do

  import Macros

  create_ok_method(:my_method, do: 1 + 2)

end