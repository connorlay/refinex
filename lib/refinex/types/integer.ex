defmodule Refinex.Integer do
  use Refinex

  type()
  refine(:is_integer)
end
