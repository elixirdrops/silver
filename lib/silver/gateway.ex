defmodule Silver.Gateway do

  @moduledoc ~S"""
  Spec to implement Silver gateway
  """

  # @TODO: fix the typespecs and docs
  @type amount :: float
  @type credit_card :: %Silver.CreditCard {}
  @type options :: Keyword.t
  @type config :: Keyword.t
  @type response :: any
  @type id :: integer

  @callback authorize(amount, credit_card, options) :: response
  @callback charge(amount, credit_card, options) :: response
  @callback capture(id, options) :: response
  @callback void(id, options) :: response
  @callback refund(amount, id, options) :: response

end