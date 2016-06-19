defmodule Silver.HttpTest do
	use ExUnit.Case
	alias Silver.Http

	@query_params [query: "apples", sort_by: "price", page: nil]

	test "filter nil values" do
		expected = Http.filter_params(@query_params)
		assert [query: "apples", sort_by: "price"] == expected
	end

	test "build and encode query params" do
		expected = Http.build_query_params(@query_params)
		assert "query=apples&sort_by=price" == expected
	end
end