defmodule Silver.Server do
  use GenServer

  def start_link(_type, _opts) do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def handle_call({:authorize, name, amount, credit_card, opts}, _form, state) do
    {gateway, config} = config_for_gateway(name)
    resp = gateway.authorize(amount, credit_card, opts, config)

    {:reply, resp, state}
  end

  def handle_call({:charge, name, amount, credit_card, opts}, _form, state) do
    {gateway, config} = config_for_gateway(name)
    resp = gateway.charge(amount, credit_card, opts, config)

    {:reply, resp, state}
  end

  defp config_for_gateway(name) do
    config = Application.get_env(:silver, name, :stripe)
    gateway = Keyword.get(config, :gateway)
    {gateway, config}
  end
end
