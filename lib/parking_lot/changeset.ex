defmodule ParkingLot.Changeset do
  @moduledoc false

  import Ecto.Changeset

  def validate_document(changeset, field) do
    validate_change(changeset, field, fn ^field, %{__struct__: type} = document ->
      digits = type.to_digits(document)

      cond do
        ParkingLot.Digits.duplicated?(digits) -> [{field, "has invalid digits"}]
        not type.valid?(document) -> [{field, "has invalid check digit"}]
        :otherwise -> []
      end
    end)
  end

  def validate_uri(changeset, field) do
    validate_change(changeset, field, fn ^field, uri ->
      cond do
        is_nil(uri.scheme) -> [{field, "is missing scheme"}]
        is_nil(uri.host) -> [{field, "is missing host"}]
        not valid_host?(uri.host) -> [{field, "has invalid host"}]
        :otherwise -> []
      end
    end)
  end

  def validate_email(changeset, field) do
    changeset
    |> validate_format(field, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(field, max: 160)
    |> unsafe_validate_unique(field, ParkingLot.Repo)
  end

  defp valid_host?(host) do
    match?({:ok, _hostent}, :inet.gethostbyname(to_charlist(host)))
  end
end
