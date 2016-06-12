defmodule Silver.Gateway.Test do
  @behaviour Silver.Gateway

  def authorize(_amount, _credit_card, _opts, _config) do
    {:ok, :authorized}
  end

  def charge(_amount, _credit_card, _opts, _config) do
    {:ok, :charged}
  end
end
