defmodule Synconf.Config do
  def start_link do
    Agent.start_link(fn -> %Conf{} end)
  end

  def start_link(filepath) do
    Agent.start_link(fn -> Conf.new(filepath) end)
  end

  def get(conf) do
    Agent.get(conf, &(&1))
  end

  def update(conf) do
    Agent.update(conf, fn -> Conf.update(conf) end)
  end

  def patch(conf, diff) do
    Agent.udpate(conf, fn -> Conf.patch(conf, diff) end)
  end    
end
