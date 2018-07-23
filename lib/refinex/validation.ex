defmodule Refinex.Validation do
  @moduledoc false

  def build!(module, parameters \\ []) do
    validate_refinex!(module)

    case module.__refinex__() do
      :type ->
        build_type!(module, parameters)

      :schema ->
        build_schema!(module)
    end
  end

  defp build_type!(module, parameters) do
    validate_refinex!(module)
    validate_enough_parameters!(module, parameters)

    Enum.each(parameters, &validate_refinex!/1)

    %Refinex.Type{
      __module__: module,
      __applied_parameters__: parameters
    }
  end

  def build_schema!(module) do
    %Refinex.Schema{
      __module__: module
    }
  end

  defp validate_refinex!(%Refinex.Type{} = type), do: type

  defp validate_refinex!(module) when is_atom(module) do
    unless refinex_module?(module) do
      raise ArgumentError, "#{module} is not a type or schema!"
    end

    module
  end

  defp refinex_module?(module) do
    Code.ensure_loaded?(module) && function_exported?(module, :__refinex__, 0)
  end

  defp validate_enough_parameters!(module, parameters) do
    unless enough_parameters?(module, parameters) do
      raise ArgumentError,
            "#{module} requires #{parameters} parameters!"
    end
  end

  defp enough_parameters?(module, parameters) do
    length(module.__parameters__()) == length(parameters)
  end
end
