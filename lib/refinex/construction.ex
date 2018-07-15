defmodule Refinex.Construction do
  @moduledoc false

  # Given a type and type parameters modules, applied
  # the parameters if they are valid types or schemas.
  # Raises if the supplied type parameters are invalid.
  def construct_type!(module, type_parameters) when is_atom(module) do
    validated_module = validate_module(module)

    unless validated_module do
      raise ArgumentError, "#{module} is not a Type or Schema!"
    end

    validated =
      type_parameters
      |> Enum.map(&validate_module/1)
      |> Enum.map(&validate_type_parameter/1)

    if Enum.all?(validated) do
      %Refinex.Type{__module__: module, __applied_parameters__: validated}
    else
      raise ArgumentError, "One or more type parameters could not be validated!"
    end
  end

  defp validate_module(%Refinex.Type{} = type) do
    type
  end

  defp validate_module(module) when is_atom(module) do
    # Load the module into memory first, then check if it is a refinex module
    if Code.ensure_loaded?(module) &&
         function_exported?(module, :__refinex__, 0) do
      module
    else
      nil
    end
  end

  defp validate_type_parameter(nil), do: nil

  defp validate_type_parameter(%Refinex.Type{} = type) do
    type
  end

  defp validate_type_parameter(module) when is_atom(module) do
    case module.__refinex__ do
      :type ->
        if Enum.empty?(module.__parameters__) do
          module
        else
          nil
        end

      :schema ->
        module
    end
  end
end
