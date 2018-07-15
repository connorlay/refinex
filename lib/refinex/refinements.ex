defmodule Refinex.Refinements do
  @moduledoc false

  # TODO: convert all type modules to %Type{}

  def refine(module, term) when is_atom(module) do
    cond do
      # Load the module into memory first
      Code.ensure_loaded?(module) == false ->
        raise ArgumentError, "Not a valid Type or Schema module!"

      # Check if the module is a type or schema
      function_exported?(module, :__type__, 0) ->
        module.__type__()
        |> Refinex.Types.apply_type_parameters!([])
        |> refine(term)

      function_exported?(module, :__schema__, 0) ->
        refine(module.__schema__(), term)

      true ->
        raise ArgumentError, "Not a valid Type or Schema module!"
    end
  end

  def refine(
        %Refinex.Type{
          __module__: module,
          __applied_parameters__: applied_parameters
        },
        term
      ) do
    %{refinements: refinements} = module.__type__()
    apply_refinements(term, applied_parameters, refinements)
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
