defmodule OtpBasics.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link __MODULE__, :ok
  end

  def init(:ok) do
    children = [
      # Define workers and child supervisors to be supervised
      # worker(OtpBasics.Worker, [arg1, arg2, arg3])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OtpBasics.Supervisor]
    supervise children, opts
  end

end
