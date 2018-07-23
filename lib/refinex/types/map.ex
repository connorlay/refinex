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

  def refine_keys_and_values(map, [key, value]) do
    results =
      Enum.flat_map(map, fn {term_key, term_value} ->
        [Refinex.check(term_key, key), Refinex.check(term_value, value)]
      end)

    Refinex.Result.flatten(__MODULE__, map, results)
  end
end
