defmodule Refinex.Boolean do
  use Refinex

  type()
  refine(:is_boolean)
end
