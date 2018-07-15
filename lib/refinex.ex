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
    errors = Refinex.Refinements.refine(type_or_schema, term)
    Enum.empty?(errors)
  end

  def check(term, type_or_schema) do
    errors = Refinex.Refinements.refine(type_or_schema, term)

    if Enum.empty?(errors) do
      {:ok, term}
    else
      {:error, errors}
    end
  end

  defmodule Error do
    @moduledoc """
    Returned (or raised) if a term fails refinement against a given type or schema.
    """

    defstruct [:message]
  end
end
