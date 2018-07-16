defmodule Refinex.Construction do
  @moduledoc false

  def build!(module) do
    validate_refinex!(module)

    case module.__refinex__() do
      :type ->
        build_type!(module)

      :schema ->
        module
    end
  end

  def build_type!(module, parameters_to_apply \\ []) do
    validate_refinex!(module)
    validate_enough_parameters!(module, parameters_to_apply)

    Enum.each(parameters_to_apply, &validate_refinex!/1)

    %Refinex.Type{
      __module__: module,
      __applied_parameters__: parameters_to_apply
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

  defp validate_enough_parameters!(module, parameters_to_apply) do
    unless enough_parameters?(module, parameters_to_apply) do
      raise ArgumentError,
            "#{module} requires #{parameters_to_apply} parameters!"
    end
  end

  defp enough_parameters?(module, parameters_to_apply) do
    length(module.__parameters__()) == length(parameters_to_apply)
  end
end
