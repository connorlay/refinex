defmodule Refinex.Refinements do
  @moduledoc false

  alias Refinex.{
    Type,
    Schema,
    Result
  }

  ##############
  # Public API #
  ##############

  def refine(%Schema{} = schema, term) do
    refine_schema(schema, term)
  end

  def refine(%Type{} = type, term) do
    refine_type(type, term)
  end

  def refine(module, term) when is_atom(module) do
    module
    |> Refinex.Validation.build!()
    |> refine(term)
  end

  def refine(kind, term) do
    Result.invalid_kind_error(kind, term)
  end

  ##################
  # Implementation #
  ##################

  defp refine_type(type, term) do
    module = type.__module__
    applied_parameters = type.__applied_parameters__
    refinements = module.__refinements__

    {_status, results} =
      Enum.reduce(refinements, {:ok, []}, fn
        # Concrete refinement functions need to return
        # a boolean
        {mod, fun, 1}, {:ok, results} ->
          if apply(mod, fun, [term]) do
            {:ok, [Result.success(type, term) | results]}
          else
            {:error,
             [
               Result.failed_refinement_error(module, term, {mod, fun, 1})
               | results
             ]}
          end

        {mod, fun, 2}, {:ok, results} ->
          # Parameterized refinement functions need to return
          # a Refinex.Result
          result = apply(mod, fun, [term, applied_parameters])

          if result.valid? do
            {:ok, [result | results]}
          else
            {:error, [result | results]}
          end

        _refinement, {:error, results} ->
          # Short-circuit refinements
          {:error, results}
      end)

    Refinex.Result.flatten(type, term, results)
  end

  defp refine_schema(_schema, _term) do
  end
end
