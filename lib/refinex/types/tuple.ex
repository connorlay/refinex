defmodule Refinex.Tuple do
  use Refinex

  type()
  refine(:is_tuple)
end
