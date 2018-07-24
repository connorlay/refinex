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

  #######################
  # Type Implementation #
  #######################

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
            result = Result.success(type, term)
            {:ok, [result | results]}
          else
            result = Result.failed_refinement_error(module, term, {mod, fun, 1})
            {:error, [result | results]}
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

    Result.flatten(type, term, results)
  end

  #########################
  # Schema Implementation #
  #########################

  defp refine_schema(schema, term) when is_map(term) do
    module = schema.__module__
    fields = module.__fields__
    refinements = module.__refinements__

    stringified_map = stringify_keys(term)

    results =
      Enum.map(fields, fn {name, kind} ->
        term_value = Map.get(stringified_map, Atom.to_string(name))
        refine(kind, term_value)
      end)

    Result.flatten(schema, term, results)
  end

  defp refine_schema(schema, term) do
    Result.cast_error(schema, term, [
      %Result.Error{message: "#{term} is not a map"}
    ])
  end

  defp stringify_keys(map) do
    map
    |> Enum.map(fn
      {key, value} when is_atom(key) ->
        {Atom.to_string(key), value}

      tuple ->
        tuple
    end)
    |> Enum.into(%{})
  end
end
