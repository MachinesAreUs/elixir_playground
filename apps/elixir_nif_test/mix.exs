defmodule ElixirNifTest.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_nif_test,
     version: "0.0.1",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.0",
     compilers: [:make, :elixir, :app],
     aliases: aliases,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  defp aliases do
    [clean: ["clean", "clean.make"]]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end

end

# Make file tasks

defmodule Mix.Tasks.Compile.Make do
  @shortdoc "Compiles helper in src"
 
  def run(_) do
    {result, _error_code} = System.cmd("make", [], stderr_to_stdout: true)
    Mix.shell.info result
    :ok
  end
end
 
defmodule Mix.Tasks.Clean.Make do
  @shortdoc "Cleans helper in src"
 
  def run(_) do
    {result, _error_code} = System.cmd("make", ['clean'], stderr_to_stdout: true)
    Mix.shell.info result
    :ok
  end
end

