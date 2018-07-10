defmodule Refinex.Macros do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      require Refinex.Macros
      import Refinex.Macros
    end
  end

  # Refinex DSL

  defmacro type(parameters \\ []) do
    quote do
      @before_compile {Refinex.Macros, :compile_type}
      @parameters unquote(parameters)
      Module.register_attribute(__MODULE__, :refinements, accumulate: true)
    end
  end

  defmacro schema(fields \\ []) do
    quote do
      @before_compile {Refinex.Macros, :compile_schema}
      @fields unquote(fields)
      Module.register_attribute(__MODULE__, :refinements, accumulate: true)
    end
  end

  defmacro refine(function_name) do
    quote do
      @refinements unquote(function_name)
    end
  end

  # Compile hooks

  defmacro compile_type(env) do
    module = env.module

    parameters =
      module
      |> Module.get_attribute(:parameters)

    refinements =
      module
      |> Module.get_attribute(:refinements)

    quote do
      def __type__ do
        %{
          parameters: unquote(parameters),
          refinements: unquote(refinements)
        }
      end
    end
  end

  defmacro compile_schema(env) do
    module = env.module

    fields =
      module
      |> Module.get_attribute(:fields)

    refinements =
      module
      |> Module.get_attribute(:refinements)

    quote do
      def __schema__ do
        %{
          fields: unquote(fields),
          refinements: unquote(refinements)
        }
      end
    end
  end
end
