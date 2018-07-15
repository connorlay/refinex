defmodule Refinex.Number do
  @moduledoc """
  `Number` is the set of all Elixir numbers.
  """

  use Refinex

  type()
  refine(:is_number)
end
