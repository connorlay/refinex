defmodule Refinex.Boolean do
  @moduledoc """
  `Boolean` is the set of Elixir boolean values: `true` and `false`.
  """

  use Refinex

  type()
  refine(:is_boolean)
end
