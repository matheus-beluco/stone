defmodule Stone do
  @moduledoc false

  @spec split_the_bill(list(map()), list()) :: map()
  def split_the_bill(shopping_list, emails) do
    bill = calculates_bill(shopping_list)
    payers = Enum.count(emails)
    value_per_payer = div(bill, payers) * 100
    values = Enum.map(1..payers, fn _ -> value_per_payer end)

    emails
    |> Enum.zip(values)
    |> Map.new()
  end

  defp calculates_bill(shopping_list) do
    Enum.reduce(shopping_list, 0, fn item, acc ->
      item[:amount] * item[:unit_price] + acc
    end)
  end
end
