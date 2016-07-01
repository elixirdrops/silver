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

  setup do
    {:ok, payment} = Silver.authorize(:paypal, 7.47, @credit_card, currency: "USD", description: "Payment Description.")
    {:ok, %{payment: payment}}
  end

  test "authorize a payment", %{payment: payment} do
    assert payment["state"] == "approved"
  end

  test "capture a authorized payment", %{payment: payment} do
    transactions = List.first(payment["transactions"]) 
    resource = List.first(transactions["related_resources"])
    authorization = resource["authorization"]
    {:ok, resp} = Silver.capture(:paypal, 7.47, authorization["id"], currency: "USD")
    assert resp["state"] == "completed"
  end
end
