defmodule Silver.UtilsTest do
	use ExUnit.Case

	test "convert number money values to cents" do
		assert 1000 == Silver.Utils.to_cents(10)
	end

	test "convert decimal money values to cents" do
		assert 1010 == Silver.Utils.to_cents(10.10)
	end
end