defmodule Stone do
  @moduledoc false

  @spec split_the_bill(list(map()), list()) :: {:ok, map()} | {:error, binary()}
  def split_the_bill(shopping_list, emails)

  def split_the_bill(shopping_list, emails)
      when length(shopping_list) == 0 or length(emails) == 0 do
    {:error, "invalid params"}
  end

  def split_the_bill(shopping_list, emails) do
    with {:ok, shopping_list} <- validate_shopping_list(shopping_list),
         {:ok, emails} <- validate_emails(emails) do
      bill = calculates_bill_in_cents(shopping_list)
      payers = Enum.count(emails)

      rest = rem(bill, payers)
      division = div(bill, payers)

      {value_per_payer, _} =
        Enum.map_reduce(1..payers, rest, fn _, acc ->
          {(division + acc), 0}
        end)

      split_bill = emails |> Enum.zip(value_per_payer) |> Map.new()

      {:ok, split_bill}
    end
  end

  defp calculates_bill_in_cents(shopping_list) do
    Enum.reduce(shopping_list, 0, fn item, acc ->
      item[:amount] * item[:unit_price] + acc
    end) * 100 |> trunc()
  end

  defp validate_shopping_list(shopping_list) do
    case Enum.any?(shopping_list, fn item -> item[:amount] < 0 || item[:unit_price] < 0 end) do
      true -> {:error, "invalid params"}
      false -> {:ok, shopping_list}
    end
  end

  defp validate_emails(emails) do
    case Enum.uniq(emails) != emails do
      true -> {:error, "invalid params"}
      false -> {:ok, emails}
    end
  end
end
