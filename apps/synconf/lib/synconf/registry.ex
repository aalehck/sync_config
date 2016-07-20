defmodule Synconf.Registry do
  use GenServer

  ## Client API

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def get(server, filename) do
    GenServer.call(server, {:get, filename})
  end

  ## Server Callbacks

  def init() do
    names = %{}
    refs = %{}
    {:ok, {names, refs}}
  end

  def handle_call({:create, filename}, _from, {names, refs}) do
    case lookup(names, name) do
      {:ok, pid} ->
	{:reply, pid, {names, refs}}
    end
  end

  def handle_call({:get, filename}, _from, {names, refs} = state) do

  end
end
