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

    parameter_vars =
      parameters
      |> Enum.map(&Macro.var(&1, nil))

    refinements =
      module
      |> Module.get_attribute(:refinements)
      |> resolve_refinements!(env)
      |> Macro.escape()

    quote do
      def __type__ do
        %{
          parameters: unquote(parameters),
          refinements: unquote(refinements)
        }
      end

      def of(unquote_splicing(parameter_vars)) do
        {__type__(), [unquote_splicing(parameter_vars)]}
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
      |> resolve_refinements!(env)
      |> Macro.escape()

    quote do
      def __schema__ do
        %{
          fields: unquote(fields),
          refinements: unquote(refinements)
        }
      end
    end
  end

  # Given a list of refinement atoms and an env, returns the resolved MFAs or
  # raises if any cannot be resolved.
  defp resolve_refinements!(refinements, env) do
    resolved =
      refinements
      |> Enum.map(&resolve_refinement(&1, env))

    if Enum.all?(resolved) do
      resolved
    else
      # TODO: add more granular errors here
      raise ArgumentError,
            "One or more refinement functions could not be resolved!"
    end
  end

  # Given a refinement atom and an env, returns the MFA of the
  # refinement function if it is defined or imported into the env module.
  # Otherwise returns `nil`.
  defp resolve_refinement(refine, env) do
    env.functions
    |> Enum.map(fn {module, funs_and_arities} ->
      cond do
        # Check if the function is defined in the env module
        Module.defines?(env.module, {refine, 1}, :def) ->
          {env.module, refine, 1}

        Module.defines?(env.module, {refine, 2}, :def) ->
          {env.module, refine, 2}

        # Check if the function is imported into the env module
        {refine, 1} in funs_and_arities ->
          {module, refine, 1}

        {refine, 2} in funs_and_arities ->
          {module, refine, 2}

        true ->
          nil
      end
    end)
    |> List.first()
  end
end
