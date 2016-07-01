defmodule Silver.Server do
  use GenServer

  def start_link(_type, _opts) do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def handle_call({:authorize, gateway, amount, credit_card, opts}, _form, state) do
    gateway = find_gateway_by_name(gateway)
    resp = gateway.authorize(amount, credit_card, opts)

    {:reply, resp, state}
  end

  def handle_call({:charge, gateway, amount, credit_card, opts}, _form, state) do
    gateway = find_gateway_by_name(gateway)
    resp = gateway.charge(amount, credit_card, opts)

    {:reply, resp, state}
  end

  def handle_call({:capture, gateway, amount, id, opts}, _form, state) do
    gateway = find_gateway_by_name(gateway)
    resp = gateway.capture(amount, id, opts)

    {:reply, resp, state}
  end

  defp find_gateway_by_name(name) do
    Application.get_env(:silver, name, :stripe)
    |> Keyword.get(:gateway)
  end
end