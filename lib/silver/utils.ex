defmodule Silver.Utils do
  def to_cents(amount) do
    (amount * 100) |> trunc
  end

  def timestamp do
  	{_date, time} = :calendar.local_time
  	:calendar.time_to_seconds(time)
  end
end