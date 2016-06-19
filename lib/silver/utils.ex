defmodule Silver.Utils do
  def to_cents(amount) do
    (amount * 100) |> trunc
  end
end