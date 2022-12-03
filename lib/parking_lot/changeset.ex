defmodule ParkingLot.Changeset do
  import Ecto.Changeset
  alias ParkingLot.Changeset.CheckDigit

  def mark_deletion(changeset) do
    now = DateTime.truncate(DateTime.utc_now(), :second)
    %{change(changeset, deleted_at: now) | action: :update}
  end

  def validate_check_digit(changeset, field) do
    validate_change(changeset, field, fn ^field, digits ->
      if CheckDigit.valid?(digits, field) do
        []
      else
        [{field, "has invalid check digit"}]
      end
    end)
  end
end
