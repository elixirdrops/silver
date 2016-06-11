defmodule SilverTest do
  use ExUnit.Case
  import Silver
  doctest Silver

  setup do
    credit_card = %Silver.CreditCard {}
    {:ok, credit_card: credit_card}
  end

  test "authorize given purchase", %{credit_card: credit_card} do
    assert authorize(:test, 100.00, credit_card) == {:ok, :authorized}
  end

  test "charge given purchase", %{credit_card: credit_card} do
    assert charge(:test, 100.00, credit_card) == {:ok, :charged}
  end
end
