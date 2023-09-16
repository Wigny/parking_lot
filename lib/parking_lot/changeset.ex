defmodule ParkingLot.Changeset do
  @moduledoc false

  import Ecto.Changeset

  def validate_uri(changeset, field) do
    validate_change(changeset, field, fn ^field, uri ->
      cond do
        is_nil(uri.scheme) ->
          [{field, "is missing scheme"}]

        is_nil(uri.host) ->
          [{field, "is missing host"}]

        match?({:error, _posix}, :inet.gethostbyname(to_charlist(uri.host))) ->
          [{field, "has invalid host"}]

        :otherwise ->
          []
      end
    end)
  end

  def validate_phone(changeset, field) do
    validate_change(changeset, field, fn ^field, phone ->
      if ParkingLot.Phone.valid?(phone) do
        []
      else
        [{field, "is invalid"}]
      end
    end)
  end

  def validate_email(changeset, field) do
    changeset
    |> validate_format(field, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(field, max: 160)
    |> unsafe_validate_unique(field, ParkingLot.Repo)
  end
end
