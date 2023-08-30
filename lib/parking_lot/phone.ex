defmodule ParkingLot.Phone do
  defstruct [:number, :country]

  def parse(number, country) when is_binary(number) do
    case PhoneNumber.parse(number, country) do
      {:ok, phone_number} ->
        struct!(__MODULE__, number: phone_number.national_number, country: country)

      {:error, error} ->
        :error
    end
  end

  def valid?(phone) do
    {:ok, phone_number} = PhoneNumber.parse(phone.number, phone.country)

    ExPhoneNumber.is_possible_number?(phone_number) and
      ExPhoneNumber.is_valid_number?(phone_number)
  end

  def to_uri(phone) do
    {:ok, phone_number} = PhoneNumber.parse(phone.number, phone.country)

    e164 = ExPhoneNumber.format(phone_number, :rfc3966)
    URI.parse(e164)
  end

  defdelegate to_string(phone), to: String.Chars.ParkingLot.Phone

  defimpl String.Chars do
    def to_string(phone) do
      {:ok, phone_number} = PhoneNumber.parse(phone.number, phone.country)

      <<?+, e164>> = ExPhoneNumber.format(phone_number, :e164)
      e164
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(phone) do
      {:ok, phone_number} = PhoneNumber.parse(phone.number, phone.country)

      ExPhoneNumber.format(phone_number, :national)
    end
  end
end
