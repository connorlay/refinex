defmodule RefinexTest do
  use ExUnit.Case
  doctest Refinex

  describe "Built-in types" do
    test "Refinex.String" do
      assert Refinex.is?("", Refinex.String)
      assert Refinex.is?("elixir", Refinex.String)
      refute Refinex.is?(:elixir, Refinex.String)
    end

    test "Refinex.List" do
      assert Refinex.is?([], Refinex.List.of(Refinex.String))

      assert Refinex.is?(["elixir", "erlang"], Refinex.List.of(Refinex.String))
      refute Refinex.is?(["elixir", :erlang], Refinex.List.of(Refinex.String))

      assert Refinex.is?(
               [["elixir"]],
               Refinex.List.of(Refinex.List.of(Refinex.String))
             )

      assert Refinex.is?(
               ["elixir", :erlang, [1, 2, 3]],
               Refinex.List.of(Refinex.Any)
             )
    end
  end
end
