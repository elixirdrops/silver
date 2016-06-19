defmodule Silver.Http do
  def post(url, params, config) do
    query_params = build_query_params(params)
    headers = build_headers(params)
    HTTPoison.post(url, query_params, headers, [hackney: config])
  end

  def get(url, params, config) do
    query_params = build_query_params(params)
    headers = build_headers(params)
    HTTPoison.get(url, query_params, headers, [hackney: config])
  end

  def build_query_params(params) do
    params |> filter_params |> URI.encode_query
  end

  def filter_params(params) do
    Enum.reject(params, fn {_key, value} -> is_nil(value) end)
  end

  def build_headers(_params) do
    [{"Content-Type", "application/x-www-form-urlencoded"}]
  end
end