defmodule Macros do
  import ExUnit.Case
	
  defmacro create_ok_method(method_name, body) do
    quote do
      def unquote(method_name)() do 
        unquote(body)
        "ok"
      end
    end
  end

  defmacro create_test_method(base_name, body) do
    quote do
      test unquote(base_name) do
        unquote body[:do]
      end
    end
  end

  defmacro create_test_with_binding(name, body) do
    quote do
      test unquote(name) do
        var!(binding) = :binding
        unquote body[:do]
      end
    end
  end

  # defmacro test_iterate_over_data(base_name, data, body) do
  #   Enum.each unquote(data), fn(item) -> 
  #     quote do
  #       test "#{unquote(base_name)} # #{item}" do
  #         unquote body
  #       end
  #     end
  #   end
  # end

  defmacro test_with_data(base_name, data, do: body) do
    quote do
      unquote(data)
      |> Enum.with_index 
      |> Enum.each fn {example, idx} ->
        IO.puts "#{Macro.to_string(idx)} -> #{Macro.to_string(example)}"
        test "#{unquote(base_name)} # #{idx}" do
          var!(tc) = :test
          #var!(sample) = quote(do: example)
          #var!(sample) = var!(example)
          var!(sample) = Macro.escape(example)
          unquote body
        end
      end
    end
  end

end

