defmodule Ver do
  defstruct [:content, :parent, :timestamp]
end

defmodule Conf do
  defstruct path: "", head: "", versions: %{}

  def new(filepath) do
    with {:ok, content} <- File.read(filepath),
	 {:ok, stat} <- File.stat(filepath),
	   chksum = :crypto.hash(:sha, content),
      do: %Conf{path: filepath,
		head: chksum,
		versions: %{chksum =>
		  %Ver{content: content,
		       parent: nil,
		       timestamp: stat.mtime}}}
  end

  def update?(conf) do
    {:ok, stat} = File.stat(conf.path)
    head_ver = conf.versions[conf.head].timestamp
    if stat.mtime >= head_ver do
      {:ok, content} = File.read(conf.path)
      :crypto.hash(:sha, content) != conf.head
    else
      false
    end
  end

  def update(conf) do
    if update?(conf) do
      with {:ok, content} <- File.read(conf.path),
	   {:ok, stat} <- File.stat(conf.path),
	     chksum = :crypto.hash(:sha, content),
	do: %Conf{path: conf.path,
		  head: chksum,
		  versions: Map.put(conf.versions,
		    chksum, %Ver{content: content,
				 parent: conf.head,
				 timestamp: stat.mtime})}
    else
      conf
    end
  end

  def current(conf) do
    conf.versions[conf.head]
  end

  def make_diff(conf, old_ver_id) do
    make_diff(conf, old_ver_id, conf.head)
  end
  def make_diff(conf, old_ver_id, new_ver_id) do
    if Map.has_key?(conf.versions, old_ver_id)
    and Map.has_key?(conf.versions, new_ver_id) do
      Diff.diff(conf.versions[old_ver_id].content, conf.versions[new_ver_id].content)
    else
      :error
    end
  end

  def patch(conf, diff) do
    patched = Diff.patch(current(conf).content, diff, &to_string/1)
    File.write(conf.path, patched)
    update(conf)
  end
end
