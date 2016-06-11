defmodule Silver.Gateway do

  @moduledoc ~S"""
  Spec to implement Silver gateway
  """

  @type amount :: float
  @type card :: %Silver.CreditCard{}
  @type options :: Keyword.t
  @type response :: any

  @callback authorize(amount, card, options) :: response
  @callback charge(amount, card, options) :: response

end
