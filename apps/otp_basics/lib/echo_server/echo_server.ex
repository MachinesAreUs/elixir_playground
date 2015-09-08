defmodule EchoServer do

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
    socket
      |> read_line()
      |> write_line(socket)
    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
