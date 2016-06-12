defmodule Silver.Utils do
  def send_req(method, url, params, config) do
    query = build_query_params(params)
    headers = build_headers(params)
    HTTPoison.request(method, url, query, headers, [hackney: config])
  end

  def build_query_params(params) do
    params |> filter_params |> URI.encode_query
  end

  defp filter_params(params) do
    Enum.filter(params, fn {_key, value} -> value != nil end)
  end

  def build_headers(_params) do
    [{"Content-Type", "application/x-www-form-urlencoded"}]
  end

  def to_cents(amount) do
    trunc(amount * 100)
  end
end
