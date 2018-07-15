defmodule Refinex.Refinements do
  @moduledoc false

  # Given a module or an already constructed type, applies all
  # refinement functions onto the term.
  # Raises if the module is not a valid Refinex type or schema.
  def refine(module, term) when is_atom(module) do
    module
    |> Refinex.Construction.construct_type!([])
    |> refine(term)
  end

  def refine(%Refinex.Type{} = type, term) do
    refinements = type.__module__.__refinements__
    parameters = type.__applied_parameters__
    apply_refinements(term, parameters, refinements)
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
