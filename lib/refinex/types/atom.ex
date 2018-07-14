defmodule Refinex.Atom do
  use Refinex

  type()
  refine(:is_atom)
end
