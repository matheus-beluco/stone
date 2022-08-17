defmodule StoneTest do
  use ExUnit.Case

  describe "split_the_bill/2" do
    test "returns the splited bill when the division is exact" do
      shopping_list = [
        %{item: "celular", amount: 10, unit_price: 200},
        %{item: "tv", amount: 5, unit_price: 100},
        %{item: "cadeira", amount: 4, unit_price: 30}
      ]

      emails = ["john@email.com", "lee@email.com", "helena@email.com", "marcos@email.com"]

      expected_response = %{
        "john@email.com" => 65_500,
        "lee@email.com" => 65_500,
        "helena@email.com" => 65_500,
        "marcos@email.com" => 65_500
      }

      {:ok, response} = Stone.split_the_bill(shopping_list, emails)
      assert response == expected_response
      assert response |> Map.values() |> Enum.sum() == 262_000
    end

    test "returns the splited bill when only one person will pay more" do
      shopping_list = [
        %{item: "celular", amount: 1, unit_price: 50},
        %{item: "tv", amount: 2, unit_price: 25}
      ]

      emails = ["john@email.com", "lee@email.com", "helena@email.com"]

      expected_response = %{
        "john@email.com" => 3_334,
        "lee@email.com" => 3_333,
        "helena@email.com" => 3_333
      }

      {:ok, response} = Stone.split_the_bill(shopping_list, emails)
      assert response == expected_response
      assert response |> Map.values() |> Enum.sum() == 10_000
    end

    test "returns the splited bill when more than one person will pay more" do
      shopping_list = [
        %{item: "celular", amount: 2, unit_price: 50},
        %{item: "tv", amount: 2, unit_price: 5}
      ]

      emails = ["john@email.com", "lee@email.com", "helena@email.com"]

      expected_response = %{
        "john@email.com" => 3667,
        "lee@email.com" => 3667,
        "helena@email.com" => 3666
      }

      {:ok, response} = Stone.split_the_bill(shopping_list, emails)
      assert response == expected_response
      assert response |> Map.values() |> Enum.sum() == 11_000
    end

    test "returns the splited bill when the bill is 1 cent" do
      shopping_list = [
        %{item: "celular", amount: 1, unit_price: 0.01}
      ]

      emails = ["john@email.com", "lee@email.com", "helena@email.com"]

      expected_response = %{
        "john@email.com" => 1,
        "lee@email.com" => 0,
        "helena@email.com" => 0
      }

      {:ok, response} = Stone.split_the_bill(shopping_list, emails)
      assert response == expected_response
      assert response |> Map.values() |> Enum.sum() == 1
    end

    test "returns error if shopping list is empty" do
      shopping_list = []
      emails = ["john@email.com", "lee@email.com", "helena@email.com", "marcos@email.com"]

      assert Stone.split_the_bill(shopping_list, emails) == {:error, "invalid params"}
    end

    test "returns error if emails is empty" do
      shopping_list = [%{item: "celular", amount: 10, unit_price: 200}]
      emails = []

      assert Stone.split_the_bill(shopping_list, emails) == {:error, "invalid params"}
    end

    test "returns error if unit_price is negative" do
      shopping_list = [%{item: "celular", amount: 10, unit_price: -1}]
      emails = ["john@email.com"]

      assert Stone.split_the_bill(shopping_list, emails) == {:error, "invalid params"}
    end

    test "returns error if amount is negative" do
      shopping_list = [%{item: "celular", amount: -1, unit_price: 10}]
      emails = ["john@email.com"]

      assert Stone.split_the_bill(shopping_list, emails) == {:error, "invalid params"}
    end

    test "returns error if exists duplicated email" do
      shopping_list = [%{item: "celular", amount: 10, unit_price: 200}]
      emails = ["john@email.com", "john@email.com"]

      assert Stone.split_the_bill(shopping_list, emails) == {:error, "invalid params"}
    end
  end
end
