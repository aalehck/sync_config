defmodule ModelTest do
  use ExUnit.Case, async: false

  test "initializing a conf" do
    path = "tmp"
    File.write(path, "")
    conf = Conf.new(path)
    assert conf.path == "tmp"
    assert conf.head == :crypto.hash(:sha, "")
    {:ok, ver} = Map.fetch(conf.versions, :crypto.hash(:sha, ""))
    assert ver.content == ""
    assert ver.parent == nil
    File.rm(path)
  end
end

