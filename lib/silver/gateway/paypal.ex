defmodule Silver.Gateway.Paypal do
  @behaviour Silver.Gateway
  @base_url "https://api.paypal.com/v1"
  @sandbox_url "https://api.sandbox.paypal.com/v1"

  def authorize(_amount, _credit_card, _opts) do
  end

  def charge(_amount, _credit_card, _opts) do
  end

  def capture(_id, _opts) do
  end

  def refund(_amount, _id, _opts) do
  end

  def void(_id, _opts) do
  end

  def send_req(:post, url, params) do
    config = []
    Silver.Http.post(url, params, config)
  end

  def url do
    case env do
      :sandbox -> @sandbox_url
      _ -> @base_url
    end
  end
  
  def env do
    Application.get_env(:pay, :paypal)
    |> Keyword.get(:env)
  end
end