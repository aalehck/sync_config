defmodule Synconf.Config do
  use GenServer

  ## Client API

  # def start_link do
  #   Agent.start_link(fn -> %Conf{} end)
  # end

  def start_link(filepath) do
    # Agent.start_link(fn -> Conf.new(filepath) end)
    GenServer.start_link(__MODULE__, Path.absname(filepath))
  end

  def get(conf) do
    # Agent.get(conf, &(&1))
    GenServer.call(conf, :get)
  end

  def update(conf) do
    # Agent.update(conf, fn -> Conf.update(conf) end)
    GenServer.call(conf, :update)
  end

  def patch(conf, diff) do
    # Agent.update(conf, fn -> Conf.patch(conf, diff) end)
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
