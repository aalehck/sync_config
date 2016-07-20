defmodule Synconf do
  use Application

  def start(_type, _args) do
    Synconf.Supervisor.start_link
  end
end
