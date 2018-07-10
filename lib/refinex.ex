defmodule Refinex do
  @moduledoc """
  An Elixir library for defining types and schemas by composing refinement functions.
  """

  defmacro __using__(_) do
    quote do
      use Refinex.Macros
    end
  end

  def is?(term, type_or_schema) do
    raise "Need to implement!"
  end
end
