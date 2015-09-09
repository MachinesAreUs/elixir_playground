defmodule OtpBasics.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link __MODULE__, :ok
  end

  def init(:ok) do
    children = [
      supervisor(Task.Supervisor, [[name: EchoServer.Task.Supervisor]]),
      worker(Task, [EchoServer, :accept, [3030]], id: EchoServerTask),
      worker(Task, [CommandServer, :accept, [4040]], id: CommandServerTask)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OtpBasics.Supervisor]
    supervise children, opts
  end

end
