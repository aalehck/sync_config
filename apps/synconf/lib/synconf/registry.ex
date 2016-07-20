defmodule Synconf.Registry do
  use GenServer

  ## Client API

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def create(server, name) do
    GenServer.call(server, {:create, name})
  end

  def get(server, filename) do
    GenServer.call(server, {:get, filename})
  end

  def stop(server) do
    GenServer.stop(server)
  end

  ## Server Callbacks

  def init() do
    {:ok, %{}}
  end

  def handle_call({:create, filename}, _from, state) do
    case get(names, name) do
      {:ok, pid} ->
	{:reply, pid, {names, refs}}

    end
  end

  def handle_call({:get, filename}, _from, state) do
    
  end
end
