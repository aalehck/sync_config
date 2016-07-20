defmodule ModelTest do
  use ExUnit.Case, async: false

  setup do
    path = Path.absname("tmp")
    File.write(path, "")
    on_exit fn ->
      File.rm(path)
    end
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

  test "patching a conf", context do
    File.write(context.path, "something")
    conf = Conf.update(context.conf)
    cp_conf = Conf.copy(conf, "tmp1")
    File.write(conf.path, "something added")
    conf = Conf.update(conf)
    diff = Conf.make_diff(conf, cp_conf.head)
    assert diff == Diff.diff("something", "something added")
    cp_conf = Conf.patch(cp_conf, diff)
    assert Conf.current(cp_conf).content == "something added"
    File.rm(cp_conf.path)
  end
end

