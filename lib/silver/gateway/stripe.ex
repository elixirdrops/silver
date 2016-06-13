defmodule Silver.Gateway.Stripe do
  @behaviour Silver.Gateway
  @base_url "https://api.stripe.com/v1"

  def authorize(amount, credit_card, opts, config) do
    charge(amount, credit_card, [capture: true] ++ opts, config)
  end

  def charge(amount, credit_card, opts, config) do
    currency = Keyword.get(opts, :currency, config[:currency])
    opts = [amount: amount, credit_card: credit_card, currency: currency] ++ opts
    params = parse_params(opts)
    config = parse_config(config)
    send_req(:post, "charges", params, config)
  end

  defp send_req(:post, url, params, config) do 
    {:ok, resp} = Silver.Utils.send_req(:post, "#{@base_url}/#{url}", params, config)
    resp |> handle_resp
  end

  defp handle_resp(%{status_code: 200, body: body}) do
    case Poison.decode(body) do
      {:ok, data} -> {:ok, data}
      {:error, msg} -> {:error, msg}
    end
  end

  defp handle_resp(_) do
    {:error, "Invalid purchase!"}
  end

  defp parse_params(opts) do
    amount = Silver.Utils.to_cents(opts[:amount])
    parse_address(opts[:address]) ++ 
    parse_credit_card(opts[:credit_card]) ++
    [customer: opts[:customer_id]
      amount: amount,
      currency: opts[:currency]
      capture: opts[:capture]
      description: opts[:description],
      destination: opts[:destination],
      application_fee: opts[:application_fee]]
  end

  defp parse_config(config) do
    [basic_auth: {config[:api_key], config[:secret]}]
  end

  defp parse_address(address = %Silver.Address {}) do
    ["card[address_line1]": address.street1,
     "card[address_line2]": address.street2,
     "card[address_city]":  address.city,
     "card[address_state]": address.state,
     "card[address_zip]":   address.postal_code,
     "card[address_country]": address.country]
  end

  defp parse_address(_), do: []

  defp parse_credit_card(credit_card = %Silver.CreditCard {}) do
    ["card[number]": credit_card.number,
     "card[exp_year]": credit_card.expiry_year,
     "card[exp_month]":  credit_card.expiry_month,
     "card[cvc]": credit_card.cvv,
     "card[name]":   "#{credit_card.first_name} #{credit_card.last_name}"]
  end

  defp parse_credit_card(id) when is_integer(id) do
    [card: id]
  end

  defp credit_card_params(_), do: []
end
