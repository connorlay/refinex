defmodule Refinex.String do
  use Refinex

  type()
  refine(:is_binary)
end
