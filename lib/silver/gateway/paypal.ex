defmodule Silver.Gateway.Paypal do
  @behaviour Silver.Gateway
  @base_url "https://api.paypal.com"
  @sandbox_url "https://api.sandbox.paypal.com"

  def authorize(amount, credit_card, opts) do
    url = build_url("/v1/payments/payment/")
    params = build_params(amount, credit_card, opts) |> encode
    IO.inspect(url)
    url
    |> Silver.Http.post(params, headers(:with_token))
    |> handle_resp
  end

  def charge(_amount, _credit_card, _opts) do
  end

  def capture(amount, id, opts) do
    url = build_url("/v1/payments/authorization/#{id}/capture")
    params = build_amount(:capture, amount, opts[:currency]) |> encode
    
    url
    |> Silver.Http.post(params)
    |> handle_resp
  end

  def refund(amount, id, opts) do
    url = build_url("/v1/payments/capture/#{id}/refund")
    params = build_amount(amount, opts[:currency]) |> encode

    url
    |> Silver.Http.post(params, headers(:with_token))
    |> handle_resp
  end

  def void(id, opts) do
    url = build_url("/v1/payments/authorization/#{id}/void")
    send_req(:post, url)
  end

  def authenticate do
    config = [basic_auth: {client_id(), secret()}]
    params = [grant_type: "client_credentials"]
    url = build_url("/v1/oauth2/token/")

    url
    |> Silver.Http.post(params, headers, config)
    |> handle_resp
    |> parse_token
    |> update_token
  end

  def send_req(:post, url, params \\ []) do
    config = []

    url
    |> build_url
    |> Silver.Http.post(url, params, headers(:with_token), config)
    |> handle_resp
  end

  def build_url(url) do
    case paypal_env() do
      :sandbox -> @sandbox_url <> url
      _ -> @base_url <> url
    end
  end

  def build_amount(:capture, amount, currency) do
    %{amount: %{total: to_string(amount), currency: currency},
      is_final_capture: true}
  end

  def build_amount(amount, currency) do
    %{amount: %{total: to_string(amount), currency: currency}}
  end

  def build_params(amount, credit_card, opts) do
    amount = build_amount(amount, opts[:currency])
    credit_card = build_credit_card(credit_card)

    %{intent: "authorize",
      payer: %{payment_method: "credit_card", funding_instruments: [credit_card]},
      transactions: [amount]}
  end

  def build_credit_card(credit_card = %Silver.CreditCard {}) do
    %{credit_card: %{
      number: credit_card.number,
      type: credit_card.type,
      expire_month: credit_card.expiry_month,
      expire_year: credit_card.expiry_year,
      cvv2: credit_card.cvv,
      first_name: credit_card.first_name,
      last_name: credit_card.last_name
    }}
  end

  @doc """
    Headers requried to make a calls to paypal api.
  """
  def headers(:with_token) do
    {token, _} = auth_token()
    [{"Authorization", "Bearer " <> token},
     {"Accept", "application/json"},
     {"Content-Type", "application/json"}]
  end

  def headers do
    [{"Content-Type", "application/x-www-form-urlencoded"},
    {"Accept", "application/json"}]
  end

  def handle_resp(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 401,  body: body, headers: _headers}} ->
        {:ok, response} = Poison.decode(body)
        {:auth_error, response}
      {:ok, %HTTPoison.Response{status_code: _, body: body, headers: _headers}} ->
        {:ok, Poison.decode!(body)}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp parse_token({:ok, resp}) do
    IO.inspect(resp)
    {:ok, Map.get(resp, "access_token"), Map.get(resp, "expires_in")}
  end

  def update_token({:ok, access_token, expires_in}) do
    timestamp = Silver.Utils.timestamp() + expires_in
    :ok = Silver.Storage.put(:auth_token, {access_token, timestamp})
    {access_token, timestamp}
  end

  def encode(data) do
    {:ok, data} = Poison.encode(data)
    data
  end

  @doc """
  Function that returns a valid token. 
  If the token has expired, it makes a call to paypal.
  """
  def auth_token do
    case is_expired do
      true -> authenticate()
      _ -> 
        Silver.Storage.get(:auth_token)
    end
  end

  defp is_expired do
    case Silver.Storage.get(:auth_token) do
      {_token, expires_in} ->
        Silver.Utils.timestamp > expires_in
      _ ->
        true
    end
  end

  def client_id do
    Application.get_env(:silver, :paypal)
    |> Keyword.get(:client_id)
  end

  def secret do
    Application.get_env(:silver, :paypal)
    |> Keyword.get(:secret)
  end

  defp paypal_env do
    Application.get_env(:silver, :paypal)
    |> Keyword.get(:env)
  end
end