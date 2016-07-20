defmodule ModelTest do
  use ExUnit.Case, async: false

  setup do
    path = Path.absname("tmp")
    File.write(path, "")
    {:ok, [path: path, conf: Conf.new(path)]}
  end

  # setup context do
  #   File.write(context.path, "")
  #   [conf: Conf.new(context.path)]
  # end

  test "initializing a conf", context do
    assert context.conf.path == Path.absname("tmp")
    assert context.conf.head == :crypto.hash(:sha, "")
    {:ok, ver} = Map.fetch(context.conf.versions, :crypto.hash(:sha, ""))
    assert ver.content == ""
    assert ver.parent == nil
  end

  test "updating a conf", context do
    assert context.conf.versions[context.conf.head].content == ""
    File.write(context.path, "hello world")
    new_conf = Conf.update(context.conf)
    assert new_conf.path == context.path
    assert new_conf.versions[new_conf.head].content == "hello world"
    assert new_conf.head == :crypto.hash(:sha, "hello world")
  end
end

