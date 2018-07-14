defmodule Refinex.Nil do
  use Refinex

  type()
  refine(:is_nil)
end
