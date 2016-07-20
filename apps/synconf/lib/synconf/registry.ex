defmodule Synconf.Registry do
  use GenServer

  ## Client API

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def create(server, name) do
    GenServer.call(server, {:create, name})
  end

  def lookup(server, filename) do
    GenServer.call(server, {:lookup, filename})
  end

  def stop(server) do
    GenServer.stop(server)
  end

  ## Server Callbacks

  def init() do
    {:ok, %{}}
  end

  def handle_cast({:create, filename}, registry) do
    if Map.has_key?(registry, filename) do
      {:noreply, registry}
    else
      {:ok, pid} = Synconf.Config.Supervisor.start_conf
      {:noreply, Map.put(registry, filename, pid)}
    end
  end

  def handle_call({:lookup, filename}, _from, registry) do
    case Map.fetch(registry, filename) do
      {:ok, pid} ->
	{:reply, {:ok, pid}, registry}
      :error ->
	{:reply, :error, registry}
    end
  end
end
