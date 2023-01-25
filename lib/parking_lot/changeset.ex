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
end
