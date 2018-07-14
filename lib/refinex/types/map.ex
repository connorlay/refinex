defmodule Refinex.Map do
  use Refinex

  type([:key, :value])
  refine(:is_map)
  refine(:refine_keys_and_values)

  def refine_keys_and_values(map, [key, value]) do
    true
  end
end
