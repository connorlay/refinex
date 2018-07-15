defmodule Refinex.Atom do
  @moduledoc """
  `Atom` is the set of all Elixir atoms.
  """

  use Refinex

  type()
  refine(:is_atom)
end
