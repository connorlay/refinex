defmodule Refinex.Map do
  use Refinex

  type([:key, :value])
  refine(:is_map)
  refine(:refine_keys_and_values)

  def refine_keys_and_values(list, [key, value]) do
    false
  end
end
