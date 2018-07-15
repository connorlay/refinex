defmodule Refinex.Tuple do
  @moduledoc """
  `Tuple` is the set of all Elixir tuples, regardless of size.
  """
  use Refinex

  type()
  refine(:is_tuple)
end
