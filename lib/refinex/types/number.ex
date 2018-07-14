defmodule Refinex.Number do
  use Refinex

  type()
  refine(:is_number)
end
