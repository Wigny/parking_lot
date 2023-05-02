defmodule ParkingLot.Changeset do
  @moduledoc false

  import Ecto.Changeset
  alias ParkingLot.{CheckDigits, Digits}

  def validate_digits(changeset, field, opts) do
    changeset
    |> validate_length(field, is: opts[:length])
    |> validate_change(field, fn ^field, value ->
      digits = Digits.to_digits(value, length: opts[:length])

      cond do
        Digits.duplicated?(digits) -> [{field, "has invalid digits"}]
        not CheckDigits.valid?(digits, opts[:weights]) -> [{field, "has invalid check digit"}]
        true -> []
      end
    end)
  end

  def validate_uri(changeset, field) do
    validate_change(changeset, field, fn ^field, uri ->
      cond do
        is_nil(uri.scheme) -> [{field, "is missing scheme"}]
        is_nil(uri.host) -> [{field, "is missing host"}]
        not valid_host?(uri.host) -> [{field, "has invalid host"}]
        true -> []
      end
    end)
  end

  defp valid_host?(host) do
    match?({:ok, _hostent}, :inet.gethostbyname(to_charlist(host)))
  end
end
