defmodule StoneTest do
  use ExUnit.Case

  describe "split_the_bill/2" do
    test "returns the amount that each email must pay" do
      shopping_list = [
        %{item: "celular", amount: 10, unit_price: 200},
        %{item: "tv", amount: 5, unit_price: 100},
        %{item: "cadeira", amount: 4, unit_price: 30}
      ]

      emails = ["john@email.com", "lee@email.com", "helena@email.com", "marcos@email.com"]

      expected_response = %{
        "john@email.com": 65.500,
        "lee@email.com": 65.500,
        "helena@email.com": 65.500,
        "marcos@email.com": 65.500
      }

      assert Stone.split_the_bill(shopping_list, emails) == expected_response
    end
  end
end
