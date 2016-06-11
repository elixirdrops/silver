defmodule Silver do
  use Application
  @name Silver.Server

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    # Define workers and child supervisors to be supervised
    children = [
      worker(Silver.Server, [[], []]),
    ]
    opts = [strategy: :one_for_one, name: Silver.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def authorize(gateway, amount, credit_card, opts \\ []) do
    GenServer.call(@name, {:authorize, gateway, amount, credit_card, opts})
  end

  def charge(gateway, amount, credit_card, opts \\ []) do
    GenServer.call(@name, {:charge, gateway, amount, credit_card, opts})
  end
end
