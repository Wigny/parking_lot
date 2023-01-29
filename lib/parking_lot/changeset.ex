defmodule ParkingLot.Changeset do
  @moduledoc false

  import Ecto.Changeset
  alias ParkingLot.CheckDigit

  def validate_check_digit(%{valid?: true} = changeset, field) do
    validate_change(changeset, field, fn ^field, digits ->
      if CheckDigit.valid?(digits, field) do
        []
      else
        [{field, "has invalid check digit"}]
      end
    end)
  end

  def validate_check_digit(changeset, _field) do
    changeset
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
