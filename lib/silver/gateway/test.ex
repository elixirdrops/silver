defmodule Silver.Gateway.Test do
  @behaviour Silver.Gateway

  def authorize(amount, credit_card, opts) do
    {:ok, :authorized}
  end

  def charge(amount, credit_card, opts) do
    {:ok, :charged}
  end
end
