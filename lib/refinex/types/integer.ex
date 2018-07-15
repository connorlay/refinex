defmodule Refinex.Integer do
  @moduledoc """
  `Integer` is the set of all Elixir integer numbers.
  """

  use Refinex

  type()
  refine(:is_integer)
end
