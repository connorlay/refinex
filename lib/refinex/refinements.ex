defmodule Refinex.Refinements do
  @moduledoc false

  # Given a module or an already constructed type, applies all
  # refinement functions onto the term.
  # Raises if the module is not a valid Refinex type or schema.
  def refine(module, term) when is_atom(module) do
    module
    |> Refinex.Construction.build!()
    |> refine(term)
  end

  def refine(%Refinex.Type{} = type, term) do
    refinements = type.__module__.__refinements__
    parameters = type.__applied_parameters__
    apply_refinements(term, parameters, refinements)
  end

  def refine(%Refinex.Schema{} = schema, term) when is_map(term) do
    fields = schema.__module__.__fields__
    stringified_map = stringify_keys(term)

    Enum.reduce(fields, [], fn
      {name, type_or_schema}, errors ->
        stringified_name = Atom.to_string(name)
        term_value = Map.get(stringified_map, stringified_name)
        refine(type_or_schema, term_value) ++ errors
    end)

    # TODO: convert stringified map to struct
  end

  def refine(%Refinex.Schema{}, term) do
    [%Refinex.Error{message: "#{inspect(term)} is not a map!"}]
  end

  # Executes each refinement predicate function on the given term
  # and its list of resolved type parameters.
  # Returns a list of errors.
  defp apply_refinements(term, parameters, refinements) do
    Enum.reduce(refinements, [], fn
      {module, fun, 1}, [] ->
        if apply(module, fun, [term]) do
          []
        else
          error = %Refinex.Error{
            message: "#{inspect(term)} failed refinement for #{module}.#{fun}/1"
          }

          [error]
        end

      {module, fun, 2}, [] ->
        if apply(module, fun, [term, parameters]) do
          []
        else
          error = %Refinex.Error{
            message: "#{inspect(term)} failed refinement for #{module}.#{fun}/2"
          }

          [error]
        end

      {_module, _fun, _arity}, errors ->
        errors
    end)
  end

  # Given a Map where the keys are atoms, converts them to strings
  defp stringify_keys(map) do
    map
    |> Enum.map(fn
      {key, value} when is_atom(key) ->
        {Atom.to_string(key), value}

      {key, value} ->
        {key, value}
    end)
    |> Enum.into(%{})
  end
end
