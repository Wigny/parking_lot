defmodule ParkingLot.Type.Phone do
  use Ecto.ParameterizedType
  alias ParkingLot.Phone

  defguardp is_phone(data) when is_struct(phone, Phone)

  def type(_params), do: :string

  def init(opts), do: %{country: opts[:country]}

  def cast(number, %{country: country}) when is_binary(number) do
    Phone.parse(number, country)
  end

  def cast(%{country: country} = phone, %{country: ^country}) when is_phone(data) do
    {:ok, phone}
  end

  def cast(phone, _params) when is_nil(phone) do
    {:ok, nil}
  end

  def cast(_phone, _params) do
    :error
  end

  def load(number, _loader, %{country: country}) when is_binary(number) do
    Phone.parse(number, country)
  end

  def load(number, _loader, _params) when is_nil(number) do
    {:ok, nil}
  end

  def dump(%{country: country} = phone, _dumper, %{country: ^country}) when is_phone(data) do
    {:ok, Phone.to_string(phone)}
  end

  def dump(phone, _dumper, _params) when is_nil(phone) do
    {:ok, nil}
  end

  def dump(_phone, _dumper, _params) do
    :error
  end
end
