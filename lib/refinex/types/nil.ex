defmodule Refinex.Nil do
  @moduledoc """
  `Nil` is the set containing the Elixir term `nil`.
  """

  use Refinex

  type()
  refine(:is_nil)

  def is_nil(term) do
    Kernel.is_nil(term)
  end
end
