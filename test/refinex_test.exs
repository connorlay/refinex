defmodule RefinexTest do
  use ExUnit.Case
  doctest Refinex

  alias Refinex.{
    String,
    List,
    Map,
    Any,
    Integer,
    Atom
  }

  describe "Built-in types" do
    test "String" do
      assert Refinex.is?("", String)
      assert Refinex.is?("elixir", String)
      refute Refinex.is?(:elixir, String)
    end

    test "List" do
      assert Refinex.is?([], List.of(String))

      assert Refinex.is?(["elixir", "erlang"], List.of(String))
      refute Refinex.is?(["elixir", :erlang], List.of(String))

      assert Refinex.is?(
               [["elixir"]],
               List.of(List.of(String))
             )

      assert Refinex.is?(
               ["elixir", :erlang, [1, 2, 3]],
               List.of(Any)
             )

      refute Refinex.is?(
               [["elixir"], [:erlang], [1, 2, 3], "apple"],
               List.of(List.of(String))
             )
    end

    test "Map" do
      assert Refinex.is?(%{}, Map.of(String, Integer))

      assert Refinex.is?(
               %{"a" => 1, "b" => 2},
               Map.of(String, Integer)
             )

      refute Refinex.is?(
               %{"a" => "b", "c" => "d"},
               Map.of(String, Integer)
             )

      assert Refinex.is?(
               %{"a" => %{a: 1}, "b" => %{b: 2}},
               Map.of(
                 String,
                 Map.of(Atom, Integer)
               )
             )
    end
  end
end
