defmodule Silver.Http do
  @timeout :infinity

  def post(url, params, headers, config \\ []) do
    query_params = build_params(params)
    HTTPotion.post(url, body: query_params, headers: headers, timeout: @timeout, basic_auth: config[:basic_auth])
  end

  def get(url, opts) do
    HTTPotion.get(url, opts)
  end

  def build_params(params) when is_binary(params) do
    params
  end

  def build_params(params) when is_list(params) do
    params |> filter_params |> URI.encode_query
  end

  def filter_params(params) do
    Enum.reject(params, fn {_key, value} -> is_nil(value) end)
  end
end