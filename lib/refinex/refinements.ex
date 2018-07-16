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

    Enum.reduce(fields, [], fn
      {name, type_or_schema}, errors ->
        # TODO: accept string and atom inputs
        term_value = Map.get(term, Atom.to_string(name))
        refine(type_or_schema, term_value) ++ errors
    end)

    # TODO: now that errors are capture, convert to struct
    # and run refinements. otherwise return errors
  end

  def refine(%Refinex.Schema{}, term) do
    [%Refinex.Error{message: "#{inspect(term)} is not a map!"}]
  end

  # Executes each refinement predicate function on the given term
  # and its list of resolved type parameters.
  # Returns a list of errors.
  defp apply_refinements(term, parameters, refinements) do
    Enum.reduce(refinements, [], fn
      {module, fun, 1}, errors ->
        if apply(module, fun, [term]) do
          errors
        else
          error = %Refinex.Error{
            message: "#{inspect(term)} failed refinement for #{module}.#{fun}/1"
          }

          [error | errors]
        end

      {module, fun, 2}, errors ->
        if apply(module, fun, [term, parameters]) do
          errors
        else
          error = %Refinex.Error{
            message: "#{inspect(term)} failed refinement for #{module}.#{fun}/2"
          }

          [error | errors]
        end
    end)
  end
end
