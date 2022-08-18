defmodule Stone do
  @moduledoc false

  @spec split_the_bill(list(map()), list()) :: {:ok, map()} | {:error, binary()}
  def split_the_bill(shopping_list, emails)

  def split_the_bill(shopping_list, emails)
      when length(shopping_list) == 0 or length(emails) == 0 do
    {:error, "params can't be empty"}
  end

  def split_the_bill(shopping_list, emails) do
    with {:ok, shopping_list} <- validate_positive_values(shopping_list),
         {:ok, emails} <- validate_unique_emails(emails),
         {:ok, bill} <- calculate_bill_in_cents(shopping_list) do
      payers = length(emails)
      bill_per_payer = calculate_bill_per_payer(bill, payers)
      split_bill = emails |> Enum.zip(bill_per_payer) |> Map.new()

      {:ok, split_bill}
    end
  end

  defp validate_positive_values(shopping_list) do
    case Enum.any?(shopping_list, fn item -> item[:amount] < 0 || item[:unit_price] < 0 end) do
      true -> {:error, "values can't be negative"}
      false -> {:ok, shopping_list}
    end
  end

  defp validate_unique_emails(emails) do
    case Enum.uniq(emails) != emails do
      true -> {:error, "emails can't be duplicated"}
      false -> {:ok, emails}
    end
  end

  defp calculate_bill_in_cents(shopping_list) do
    bill =
      Enum.reduce(shopping_list, 0, fn item, acc ->
        item[:amount] * item[:unit_price] + acc
      end)

    bill_in_cents = (bill * 100) |> trunc()

    case bill_in_cents > 0 do
      true -> {:ok, bill_in_cents}
      false -> {:error, "the bill must be greater than zero"}
    end
  end

  defp calculate_bill_per_payer(bill, payers) do
    equal_bill_division = div(bill, payers)
    bill_rest = rem(bill, payers)

    {bill_per_payer, _} =
      Enum.map_reduce(1..payers, bill_rest, fn _, acc ->
        bill_increment = if acc > 1, do: 1, else: acc
        {equal_bill_division + bill_increment, acc - bill_increment}
      end)

    bill_per_payer
  end
end
