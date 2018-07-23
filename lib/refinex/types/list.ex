defmodule Refinex.List do
  @moduledoc """
  `List` is the set of all Elixir lists. `List` must be constructed with
  an `item` type parameter, which corresponds to the type of elements in the
  list.
  """

  use Refinex

  type([:item])
  refine(:is_list)
  refine(:refine_items)

  def refine_items(list, [item]) do
    results = Enum.map(list, &Refinex.check(&1, item))

    if Enum.all?(results, & &1.valid?) do
      Refinex.Result.success(__MODULE__, list)
    else
      flattened_errors =
        results
        |> Enum.map(& &1.errors)
        |> Enum.reduce([], fn errors, all_errors ->
          all_errors ++ errors
        end)

      Refinex.Result.cast_error(__MODULE__, list, flattened_errors)
    end
  end
end
