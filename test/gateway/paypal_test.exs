defmodule Silver.Gateway.PaypalTest do
  use ExUnit.Case
  @credit_card %Silver.CreditCard {
      first_name: "John",
      last_name: "Doe",
      expiry_month: 07,
      expiry_year: 2021,
      type: "visa",
      number: 4032038439477542,
      cvv: 123
    }

  test "authorization a payment" do
  	{:ok, resp} = Silver.authorize(:paypal, 7.47, @credit_card, currency: "USD", description: "Payment Description.")
    assert resp["state"] == "approved"

  end

end
