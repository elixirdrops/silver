defmodule Silver.Gateway.Test do
  @behaviour Silver.Gateway

  def authorize(_amount, _credit_card, _opts) do
    {:ok, :authorized}
  end

  def charge(_amount, _credit_card, _opts) do
    {:ok, :charged}
  end

  def capture(_id, _opts) do
    {:ok, :captured}
  end

  def refund(_amount, _id, _opts) do
    {:ok, :charged}
  end

  def void(_id, _opts) do
    {:ok, :charged}
  end
end
