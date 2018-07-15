defmodule Refinex.Float do
  @moduledoc """
  `Float` is the set of all Elixir floating-point numbers.
  """

  use Refinex

  type()
  refine(:is_float)
end
