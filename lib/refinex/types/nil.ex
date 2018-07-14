defmodule Refinex.Nil do
  use Refinex

  type()
  refine(:is_nil)

  def is_nil(term) do
    Kernel.is_nil(term)
  end
end
