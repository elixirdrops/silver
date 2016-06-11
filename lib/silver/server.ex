defmodule Silver.Server do
  use GenServer

  def start_link(_type, _opts) do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def handle_call({:authorize, gateway_name, amount, credit_card, opts}, _form, state) do
    resp = gateway(gateway_name).authorize(amount, credit_card, opts)
    {:reply, resp, state}
  end

  def handle_call({:charge, gateway_name, amount, credit_card, opts}, _form, state) do
    resp = gateway(gateway_name).charge(amount, credit_card, opts)
    {:reply, resp, state}
  end

  defp gateway(name \\ :stripe) do
     Application.get_env(:silver, name)
     |> Keyword.get(:gateway)
  end
end
