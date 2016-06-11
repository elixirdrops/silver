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
end
