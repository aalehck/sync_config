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
    if stat.mtime > head_ver do
      {:ok, content} = File.read(conf.path)
      :crypto.hash(:sha, content) != conf.head
    else
      false
    end
  end

  def update(conf) do
    case update?(conf) do
      true ->
	with {:ok, content} <- File.read(conf.path),
	     {:ok, stat} <- File.stat(conf.path),
	       chksum = :crypto.hash(:sha, content),
	  do: %Conf{path: conf.path,
		    head: chksum,
		    versions: Map.put(conf.versions,
		      chksum, %Ver{content: content,
				   parent: conf.head,
				   timestamp: stat.mtime})}
      false ->
	conf
    end
  end

  # def patch(conf, diff) do

  # end
end
