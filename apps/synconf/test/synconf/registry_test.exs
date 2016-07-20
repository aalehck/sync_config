# defmodule Synconf.RegistryTest do
#   use ExUnit.Case

#   setup context do
#     {:ok, _} = Synconf.Registry.start_link(context.test)
#     {:ok, registry: context.test}
#   end

#   test "spawn config monitors", %{registry: registry} do
#     assert Synconf.Registry.get(registry, "tmp") == :error

#     Synconf.Registry.create(registry, "tmp")
#     assert {:ok, conf} = Synconf.Registry.get(registry, "tmp")
#   end
# end
