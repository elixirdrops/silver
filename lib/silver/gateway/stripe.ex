defmodule Silver.Gateway.Stripe do
  @behaviour Silver.Gateway
  @base_url "https://api.stripe.com/v1"

  def authorize(amount, credit_card, opts) do
    charge(amount, credit_card, [capture: true] ++ opts)
  end

  def charge(amount, credit_card, opts) do
    params = build_params(amount, credit_card, opts)
    send_req(:post, "charges", params)
  end

  def capture(_id, _opts) do
    # capture
  end

  def void(_id, _ops) do
    # void
  end

  def refund(_amount, _id, _opts) do
  end

  defp send_req(:post, url, params) do 
    config = [basic_auth: {api_key, secret}]
    {:ok, resp} = Silver.Http.post("#{@base_url}/#{url}", params, headers, config)
    resp |> handle_resp
  end

  def handle_resp(%{status_code: 200, body: body}) do
    case Poison.decode(body) do
      {:ok, data} -> {:ok, data}
      {:error, msg} -> {:error, msg}
    end
  end
  def handle_resp(_), do: {:error, "Invalid purchase!"}

  defp build_params(amount, credit_card, opts) do
    currency = Keyword.get(opts, :currency, default_currency)
    address = Keyword.get(opts, :address)

    build_address(address) ++ 
    build_credit_card(credit_card) ++
    [amount: Silver.Utils.to_cents(amount),
      currency: currency,
      capture: opts[:capture],
      customer: opts[:customer_id],
      description: opts[:description],
      destination: opts[:destination],
      application_fee: opts[:application_fee]]
  end

  def build_address(address = %Silver.Address {}) do
    ["card[address_line1]": address.street1,
     "card[address_line2]": address.street2,
     "card[address_city]": address.city,
     "card[address_state]": address.state,
     "card[address_zip]": address.postal_code,
     "card[address_country]": address.country]
  end
  def build_address(_), do: []

  def build_credit_card(credit_card = %Silver.CreditCard {}) do
    ["card[number]": credit_card.number,
     "card[exp_year]": credit_card.expiry_year,
     "card[exp_month]":  credit_card.expiry_month,
     "card[cvc]": credit_card.cvv,
     "card[name]":   "#{credit_card.first_name} #{credit_card.last_name}"]
  end

  def build_credit_card(id) when is_integer(id) do
    [card: id]
  end
  def build_credit_card(_), do: []

  # gateway config stuff
  defp headers do
    [{"Content-Type", "application/x-www-form-urlencoded"}]
  end

  defp config do
    Application.get_env(:silver, :stripe)
  end

  defp api_key do
    config |> Keyword.get(:api_key)
  end

  defp secret do
    config |> Keyword.get(:secret)
  end
  
  defp default_currency do
    config |> Keyword.get(:currency)
  end
end