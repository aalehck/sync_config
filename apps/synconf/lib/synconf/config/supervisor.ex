defmodule Synconf.Config.Supervisor do
  use Supervisor

  @name __MODULE__

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_conf(filepath) do
    Supervisor.start_child(@name, [filepath])
  end

  def init(:ok) do
    children = [
      worker(Synconf.Config, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
