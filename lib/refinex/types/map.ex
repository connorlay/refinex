defmodule Refinex.Map do
  use Refinex

  type([:key, :value])
  refine(:is_map)
  refine(:refine_keys_and_values)

  def refine_keys_and_values(list, [key, value]) do
    list
    |> Enum.map(fn {term_key, term_value} ->
      Refinex.is?(term_key, key) && Refinex.is?(term_value, value)
    end)
    |> Enum.all?()
  end
end
