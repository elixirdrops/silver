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

  def authenticate do
    config = [basic_auth: {client_id(), secret()}]
    params = [grant_type: "client_credentials"]
    url = build_url("/oauth2/token?grant_type=authorization_code")

    url
    |> Silver.Http.post(params, headers, config)
    |> handle_resp
    |> parse_token
    |> update_token
  end

  def send_req(:post, url, params) do
    config = []

    url
    |> build_url
    |> Silver.Http.post(url, params, headers(), config)
    |> handle_resp
  end

  def build_url(url) do
    case env() do
      :sandbox -> @sandbox_url <> url
      _ -> @base_url <> url
    end
  end

  @doc """
    Headers requried to make a calls to paypal api.
  """
  def headers(:json) do
    {token, _} = auth_token()
    [{"Authorization", "Bearer " <>  token},
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

  defp parse_token({:ok, response}) do
    IO.inspect(response)
    {:ok, Map.get(response, "access_token"), Map.get(response, "expires_in")}
  end

  def update_token({:ok, access_token, expires_in}) do
    timestamp = Silver.Utils.timestamp() + expires_in
    Silver.Storage.put(:auth_token, {access_token, timestamp})
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
        Silver.Utils.timestamp() > expires_in
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

  defp env do
    Application.get_env(:silver, :paypal)
    |> Keyword.get(:env)
  end
end