defmodule Refinex.Union do
  @moduledoc """
  `Union` is the intersection of all Elixir terms defined by two
  Types or Schemas.
  """

  use Refinex

  type([:left, :right])
  refine(:is_left_or_right)

  def is_left_or_right(union, [left, right]) do
    left_result = Refinex.check(union, left)
    right_result = Refinex.check(union, right)

    cond do
      left_result.valid? ->
        left_result

      right_result.valid? ->
        right_result

      true ->
        Refinex.Result.cast_error(__MODULE__, union, [left_result, right_result])
    end
  end
end
