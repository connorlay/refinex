defmodule RefinexTest do
  use ExUnit.Case
  doctest Refinex

  alias Refinex.{
    Any,
    Atom,
    Boolean,
    Float,
    Integer,
    List,
    Map,
    Nil,
    Number,
    String,
    Tuple,
    Union
  }

  describe "Built-in types" do
    test "Any" do
      assert Refinex.is?("elixir", Any)
      assert Refinex.is?(:elixir, Any)
      assert Refinex.is?([:elixir, "elixir"], Any)
      assert Refinex.is?(nil, Any)
    end

    test "Atom" do
      assert Refinex.is?(:elixir, Atom)
      assert Refinex.is?(Elixir, Atom)
      refute Refinex.is?("elixir", Atom)
    end

    test "Boolean" do
      assert Refinex.is?(true, Boolean)
      assert Refinex.is?(false, Boolean)
      refute Refinex.is?(nil, Boolean)
    end

    test "Float" do
      refute Refinex.is?(0, Float)
      refute Refinex.is?(10, Float)
      assert Refinex.is?(10.2, Float)
      refute Refinex.is?(-10, Float)
      assert Refinex.is?(-10.2, Float)
      refute Refinex.is?("10", Float)
    end

    test "Integer" do
      assert Refinex.is?(0, Integer)
      assert Refinex.is?(10, Integer)
      refute Refinex.is?(10.2, Integer)
      assert Refinex.is?(-10, Integer)
      refute Refinex.is?(-10.2, Integer)
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
               Map.of(String, Map.of(Atom, Integer))
             )
    end

    test "Nil" do
      assert Refinex.is?(nil, Nil)
      refute Refinex.is?(false, Nil)
    end

    test "Number" do
      assert Refinex.is?(0, Number)
      assert Refinex.is?(10, Number)
      assert Refinex.is?(10.2, Number)
      assert Refinex.is?(-10, Number)
      assert Refinex.is?(-10.2, Number)
      refute Refinex.is?("10", Number)
    end

    test "String" do
      assert Refinex.is?("", String)
      assert Refinex.is?("elixir", String)
      refute Refinex.is?(:elixir, String)
    end

    test "Tuple" do
      assert Refinex.is?({}, Tuple)
      assert Refinex.is?({:a, :b}, Tuple)
      refute Refinex.is?(%{a: :b}, Tuple)
    end

    test "Union" do
      assert Refinex.is?("elixir", Union.of(String, Nil))
      assert Refinex.is?(nil, Union.of(String, Nil))
    end
  end

  describe "Schema" do
    defmodule Widget do
      use Refinex

      schema(
        a: Atom,
        b: String,
        c: List.of(Integer),
        d: Union.of(__MODULE__, Nil)
      )
    end
  end

  test "Widget" do
    refute Refinex.is?(%{}, RefinexTest.Widget)

    assert Refinex.is?(
             %{
               a: :atom,
               b: "string",
               c: [1, 2, 3],
               d: nil
             },
             RefinexTest.Widget
           )

    assert Refinex.is?(
             %{
               "a" => :atom,
               "b" => "string",
               "c" => [1, 2, 3],
               "d" => nil
             },
             RefinexTest.Widget
           )

    assert Refinex.is?(
             %{
               a: :atom,
               b: "string",
               c: [1, 2, 3],
               d: %{
                 a: :atom,
                 b: "string",
                 c: [1, 2, 3],
                 d: nil
               }
             },
             RefinexTest.Widget
           )
  end
end
