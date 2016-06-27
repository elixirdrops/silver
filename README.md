# Silver

$ilver a payment library for elixir.

## Installation

If [available in Hex](https://hex.pm/package/silver), the package can be installed as:

  1. Add silver to your list of dependencies in `mix.exs`:

        def deps do
          [{:silver, "~> 0.0.1"}]
        end

  2. Ensure silver is started before your application:

        def application do
          [applications: [:silver]]
        end

## Usage

### Stripe
    address = %Silver.Address {
      street1: "123 Street",
      street2: "",
      city: "Dubai",
      state: "Dubai",
      country: "UAE",
      postal_code: "10001",
      phone: ""
    }

    credit_card = %Silver.CreditCard {
      first_name: "John",
      last_name: "Doe",
      expiry_month: 09,
      expiry_year: 2017,
      type: "visa",
      number: 4242424242424242,
      cvv: 123
    }

    case CreditCard.valid?(credit_card) do
      {:ok, card} -> 
        # authorize using Silver.authorize() or make the purcahse
        Silver.charge(:stripe, 100.00, credit_card, address: address, description: "Frog Tshirt - Order # 1")
      {:error, errors} ->
        "Credit Card is not valid, do you have another one?"
    end

### Paypal example
    Silver.authorize(:paypal, 7.47, credit_card, currency: "USD", description: "Payment Description.")

## Note

Please note this is WIP, I am only working on it after hours, if you would like 
to sponser this project, please contact me.

### License

MIT copyright @ al-razi (saytoally@hotmail.com)
