defmodule Refinex.Union do
  @moduledoc """
  `Union` is the intersection of all Elixir terms defined by two
  Types or Schemas.
  """

  use Refinex

  type([:left, :right])
  refine(:is_left_or_right)

  def is_left_or_right(union, [left, right]) do
    Refinex.is?(union, left) || Refinex.is?(union, right)
  end
end
