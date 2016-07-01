defmodule Silver.CreditCard do
  defstruct [
    :first_name,
    :last_name,
    :expiry_month,
    :expiry_year,
    :type,
    :number,
    :cvv
  ]

  def valid?(credit_card) do
  	credit_card
  	|> Integer.digits
  	|> Enum.reverse
  	|> Enum.chunk(2, 2, [0])
  	|> Enum.reduce(0, &sum/2)
  	|> rem(10) == 0
  end

  def sum([odd, even], sum) do
  	Enum.sum([sum, odd | Integer.digits( even * 2)])
  end
end
