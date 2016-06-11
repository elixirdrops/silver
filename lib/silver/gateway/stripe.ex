defmodule Silver.Gateway.Stripe do
  @behaviour Silver.Gateway
  @base_url "http://stripe.com/api"

  def authorize(amount, credit_card, opts) do
    IO.inspect([opts, credit_card])
    IO.puts "#{amount} was authorized."
  end

  def charge(amount, credit_card, opts) do
    IO.inspect([opts, credit_card])
    IO.puts "#{amount} was charged."
  end
end
