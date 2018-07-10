defmodule RefinexTest do
  use ExUnit.Case
  doctest Refinex

  describe "Built-in types" do
    test "Refinex.String" do
      assert Refinex.is?("elixir", Refinex.String)
      refute Refinex.is?(:elixir, Refinex.String)
    end
  end
end
