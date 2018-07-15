defmodule Refinex.String do
  @moduledoc """
  `String` is the set of all Elixir strings.
  """

  use Refinex

  type()
  refine(:is_binary)
end
