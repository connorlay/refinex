# Refinex

An Elixir library for defining types and schemas by composing refinement functions.

## Guide

You can define new _types_ and _schemas_ using the Refinex DSL:

```elixir
defmodule String do
  use Refinex

  type()
  refine(:is_binary)
end

defmodule Integer do
  use Refinex

  type()
  refine(:is_integer)
end

defmodule List do
  use Refinex

  type([:item])
  refine(:is_list)
  refine(:validate_items)

  def validate_items(list, [item]) do
    list
    |> Enum.map(&Refinex.is?(&1, item))
    |> Enum.all?()
  end
end

defmodule Person do
  use Refinex

  schema(name: String, age: Integer, friends: List.of(Person))
  refine(:is_adult)

  def is_adult(person) do
    person.age >= 18
  end
end
```

Once defined, you can validate any Elixir term against these _type_ and _schema_
definitions.

```elixir
iex> Refinex.is?("elixir", String)
true

iex> Refinex.is?(:elixir, String)
false

iex> Refinex.is?([], List.of(String))
true

iex> Refinex.is?(["elixir", "erlang"], List.of(String))
true

iex> Refinex.is?(["elixir", :erlang], List.of(String))
false

iex> Refinex.is?(%{"name" => "John Doe", "age" => 30, friends => []}, Person)
true

iex> Refinex.is?(%{"name" => "John Doe", "age" => 30, "friends" => [%{"name" => "Mary Sue", "age" => 32, "friends" => []}]}, Person)
true

iex> Refinex.is?(%{}, Person)
false
```

## Installation

Add the following to your `mix.exs` file:

```elixir
def deps do
  [
    {:refinex, "~> 0.1.0"}
  ]
end
```
