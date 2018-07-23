defmodule Refinex.Result do
  @moduledoc """
  Struct that represents the result of checking
  an Elixir term against a type or schema.
  """

  defstruct [
    :kind,
    :original_term,
    :cast_term,
    :errors,
    :valid?
  ]

  defmodule Error do
    defexception [:message]
  end

  def flatten(kind, term, results) do
    if Enum.all?(results, & &1.valid?) do
      Refinex.Result.success(kind, term)
    else
      flattened_errors =
        results
        |> Enum.map(& &1.errors)
        |> Enum.reduce([], fn errors, all_errors ->
          all_errors ++ errors
        end)

      Refinex.Result.cast_error(kind, term, flattened_errors)
    end
  end

  def success(kind, original_term, cast_term \\ nil) do
    %__MODULE__{
      kind: kind,
      original_term: original_term,
      cast_term: cast_term,
      errors: [],
      valid?: true
    }
  end

  def invalid_kind_error(kind, term) do
    %__MODULE__{
      kind: kind,
      original_term: term,
      cast_term: nil,
      errors: [
        %Error{
          message: "#{inspect(kind)} is not a Type or Schema"
        }
      ],
      valid?: false
    }
  end

  def failed_refinement_error(kind, term, {mod, fun, arity}) do
    %__MODULE__{
      kind: kind,
      original_term: term,
      cast_term: nil,
      errors: [
        %Error{
          message: "#{inspect(term)} failed for #{mod}.#{fun}/#{arity}"
        }
      ],
      valid?: false
    }
  end

  def cast_error(kind, term, errors) do
    %__MODULE__{
      kind: kind,
      original_term: term,
      cast_term: nil,
      errors: errors,
      valid?: false
    }
  end
end
