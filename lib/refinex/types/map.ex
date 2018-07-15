defmodule Refinex.Map do
  @moduledoc """
  `Map` is the set of all Elixir maps and structs. `Map` must be constructed with
  a `key` type parameter and a `value` type parameter, which corresponds to the
  type of elements in the map.
  """

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
