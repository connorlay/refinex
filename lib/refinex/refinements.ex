defmodule Refinex.Refinements do
  @moduledoc false

  # TODO: convert all type modules to %Constructed{}

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
        %Refinex.Types.Constructed{
          module: module,
          applied_parameters: applied_parameters
        },
        term
      ) do
    %{refinements: refinements} = module.__type__()
    apply_refinements(term, applied_parameters, refinements)
  end

  defp apply_refinements(term, parameters, refinements) do
    Enum.reduce(refinements, [], fn {module, fun, arity}, errors ->
      case arity do
        1 ->
          # TODO: handle recursive refinement errors
          if apply(module, fun, [term]) do
            errors
          else
            error = %Refinex.Error{
              message:
                "#{inspect(term)} failed refinement for #{module}.#{fun}/1"
            }

            [error | errors]
          end

        2 ->
          if apply(module, fun, [term, parameters]) do
            errors
          else
            error = %Refinex.Error{
              message:
                "#{inspect(term)} failed refinement for #{module}.#{fun}/2"
            }

            [error | errors]
          end
      end
    end)
  end
end
