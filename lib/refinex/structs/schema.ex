defmodule Refinex.Schema do
  @moduledoc false
  # Represents a schema
  defstruct __module__: nil

  defimpl Inspect, for: Refinex.Schema do
    def inspect(type, _opts) do
      "##{type.__module__}<>"
    end
  end
end
