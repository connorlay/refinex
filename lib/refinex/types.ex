defmodule Refinex.Types do
  @moduledoc false

  defmodule Constructed do
    defstruct [
      :module,
      :applied_parameters
    ]
  end

  # Given a type and type parameters modules, applied
  # the parameters if they are valid types or schemas.
  # Raises if the supplied type parameters are invalid.
  def apply_type_parameters!(type, type_parameters) do
    resolved =
      type_parameters
      |> Enum.map(&resolve_type_parameter/1)

    if Enum.all?(resolved) do
      %Constructed{module: type.module, applied_parameters: resolved}
    else
      raise ArgumentError, "One or more type parameters could not be resolved!"
    end
  end

  defp resolve_type_parameter(%Constructed{} = type) do
    type
  end

  defp resolve_type_parameter(module) do
    cond do
      # Load the module into memory first
      Code.ensure_loaded?(module) == false ->
        nil

      # Check if the module is a type or schema
      function_exported?(module, :__type__, 0) ->
        %Constructed{module: module, applied_parameters: []}

      function_exported?(module, :__schema__, 0) ->
        module

      true ->
        nil
    end
  end
end
