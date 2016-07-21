defmodule Synconf.Registry do
  use GenServer

  ## Client API

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get(server) do
    GenServer.call(server, :get)
  end

  def add_conf(server, conf) do
    GenServer.call(server, {:add, conf})
  end

  ## Server Callbacks

  def init(:ok) do
    confs = %{}
    groups = []
    {:ok, {confs, groups}}
  end

  def handle_call({:add, conf}, _from, {confs, groups} = state) do
    new_state = {Map.put(confs, Synconf.Config.get(conf).path, conf), groups}
    {:reply, new_state, new_state}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end

# defmodule Synconf.Registry do
#   use GenServer

#   ## Client API

#   def start_link(name) do
#     GenServer.start_link(__MODULE__, name, name: name)
#   end

#   def create(server, name) do
#     GenServer.call(server, {:create, name})
#   end

#   def lookup(server, filename) do
#     GenServer.call(server, {:lookup, filename})
#   end

#   def stop(server) do
#     GenServer.stop(server)
#   end

#   ## Server Callbacks

#   def init() do
#     {:ok, %{}}
#   end

#   def handle_cast({:create, filename}, registry) do
#     if Map.has_key?(registry, filename) do
#       {:noreply, registry}
#     else
#       {:ok, pid} = Synconf.Config.Supervisor.start_conf
#       {:noreply, Map.put(registry, filename, pid)}
#     end
#   end

#   def handle_call({:lookup, filename}, _from, registry) do
#     case Map.fetch(registry, filename) do
#       {:ok, pid} ->
# 	{:reply, {:ok, pid}, registry}
#       :error ->
# 	{:reply, :error, registry}
#     end
#   end
# end
