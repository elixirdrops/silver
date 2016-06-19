defmodule Silver.Gateway.StripeTest do
  use ExUnit.Case
  alias Silver.Gateway.Stripe
  doctest Silver

  setup do
    credit_card = %Silver.CreditCard {
      first_name: "John",
      last_name: "Doe",
      expiry_month: 09,
      expiry_year: 2017,
      type: "Visa",
      number: 4242424242424242,
      cvv: 123
    }
    address = %Silver.Address {
      street1: "123 Street",
      street2: "",
      city: "Dubai",
      state: "Dubai",
      country: "UAE",
      postal_code: "10001",
      phone: ""
    }
    {:ok, credit_card: credit_card, address: address}
  end

  test "given credit card format", %{credit_card: credit_card} do
    expected_format = [
      "card[number]": 4242424242424242,
      "card[exp_year]": 2017,
      "card[exp_month]":  09,
      "card[cvc]": 123,
      "card[name]":   "John Doe"
    ]
    assert Stripe.build_credit_card(credit_card) == expected_format
  end

  test "given address format", %{address: address} do
    expected_format = [
      "card[address_line1]": "123 Street",
      "card[address_line2]": "",
      "card[address_city]":  "Dubai",
      "card[address_state]": "Dubai",
      "card[address_zip]": "10001",
      "card[address_country]": "UAE"
    ]
    assert Stripe.build_address(address) == expected_format
  end
end
