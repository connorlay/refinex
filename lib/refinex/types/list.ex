defmodule Refinex.List do
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
