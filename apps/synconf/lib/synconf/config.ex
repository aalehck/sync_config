defmodule Synconf.Config do
  use GenServer

  ## Client API

  def start_link(filepath) do
    GenServer.start_link(__MODULE__, Path.absname(filepath))
  end

  def get(conf) do
    GenServer.call(conf, :get)
  end

  def update(conf) do
    GenServer.call(conf, :update)
  end

  def patch(conf, diff) do
    GenServer.call(conf, {:patch, diff})
  end

  ## Server Callbacks

  def init(filepath) do
    {:ok, Conf.new(filepath)}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:update, _from, state) do
    new_state = Conf.update(state)
    {:reply, new_state, new_state}
  end

  def handle_call({:patch, diff}, _from, state) do
    new_state = Conf.patch(state, diff)
    {:reply, new_state, new_state}
  end
end
