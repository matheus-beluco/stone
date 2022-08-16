defmodule Stone do
  @moduledoc false

  @spec split_the_bill(list(map()), list()) :: {:ok, map()} | {:error, binary()}
  def split_the_bill(shopping_list, emails)

  def split_the_bill(shopping_list, emails)
      when length(shopping_list) == 0 or length(emails) == 0 do
    {:error, "invalid params"}
  end

  def split_the_bill(shopping_list, emails) do
    bill = calculates_bill(shopping_list)
    payers = Enum.count(emails)
    value_per_payer = div(bill, payers) * 100
    values = Enum.map(1..payers, fn _ -> value_per_payer end)
    split_bill = emails |> Enum.zip(values) |> Map.new()

    {:ok, split_bill}
  end

  defp calculates_bill(shopping_list) do
    Enum.reduce(shopping_list, 0, fn item, acc ->
      item[:amount] * item[:unit_price] + acc
    end)
  end
end
