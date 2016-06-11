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

  alias Silver.CreditCard
  alias Silver.Address
  alias Silver.Order

  address = %Address {
    street1: "123 Street",
    street2: "",
    city: "Dubai",
    state: "Dubai",
    country: "UAE",
    postal_code: "10001",
    phone: ""
  }

  credit_card = %CreditCard {
    "first_name" => "John",
    "last_name" => "Doe",
    "expiry_month" => 09,
    "expiry_year" => 2017,
    "type" => "Visa",
    "number" => 12321313132,
    "cvv" => 123
  }

  case CreditCard.valid?(credit_card) do
    {:ok, card} -> 
      # authorize using Silver.authorize() or make the purcahse
      Silver.purchase(:paypal, 100.00, card, address, "Frog Tshirt - Order # 1")
    {:error, errors} ->
      "Credit Card is not valid, do you have another one?"
  end


Please note this is WIP, I am only working on it after hours, if you would like
to sponser this project, please contact me.

### License
MIT copyright @ al-raz (saytoally@hotmail.com)
