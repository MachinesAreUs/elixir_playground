defmodule CommandServer do

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, 
                      [:binary, packet: :line, active: false, reuseaddr: true])
    IO.puts "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  def loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    #Task.start_link(fn -> serve(client) end)
    {:ok, pid} = Task.Supervisor.start_child(EchoServer.Task.Supervisor,
                                             fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    msg =
      case read_line(socket) do
        {:ok, data} ->
          case CommandServer.Command.parse(data) do
            {:ok, command} ->
              CommandServer.Command.run(command)
            {:error, _} = err ->
              err
          end
        {:error, _} = err ->
          err
      end
    case msg do
      {:error, :closed} ->
        msg
      _ -> 
        write_line(socket, msg)
        serve(socket)
    end
  end

  defp read_line(socket) do
    :gen_tcp.recv socket, 0
  end

  defp write_line(socket, msg) do
    :gen_tcp.send socket, format_msg(msg)
  end

  defp format_msg({:ok, text}), do: "#{text}\r\n"
  defp format_msg({:error, :unknown_command}), do: "UNKNOWN COMMAND\r\n"
  defp format_msg({:error, _}), do: "ERROR\r\n"
end
