defmodule Silver.Http do
  def post(url, params, headers, config) do
    IO.inspect(url)
    query_params = build_params(params)
    HTTPoison.post(url, query_params, headers, [hackney: config])
  end

  def get(url, params, headers, config) do
    query_params = build_params(params)
    HTTPoison.get(url, query_params, headers, [hackney: config])
  end

  def build_params(params) do
    params |> filter_params |> URI.encode_query
  end

  def filter_params(params) do
    Enum.reject(params, fn {_key, value} -> is_nil(value) end)
  end
end