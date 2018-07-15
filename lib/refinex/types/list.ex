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
    list
    |> Enum.map(&Refinex.is?(&1, item))
    |> Enum.all?()
  end
end
