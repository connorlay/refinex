defmodule Refinex.Type do
  @moduledoc false
  # Represents a type with applied parameters
  defstruct __module__: nil,
            __applied_parameters__: []

  defimpl Inspect, for: Refinex.Type do
    def inspect(type, _opts) do
      inspected_parameters =
        type.__applied_parameters__
        |> Enum.map(&inspect/1)
        |> Enum.join(",")

      "##{type.__module__}<" <> inspected_parameters <> ">"
    end
  end
end
