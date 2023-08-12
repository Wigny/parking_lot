defmodule ParkingLot.Type.Phone do

  use Ecto.Type

  defstruct [:region_code, :national_number]

  def type, do: :string

  def cast(data) when is_binary(data) do
    with {:error, _error} <- parse(data), do: :error
  end

  def load(data) when is_binary(data) do
    with {:error, _error} <- parse(data), do: :error
  end


  def load(data) when is_nil(data) do
    {:ok, nil}
  end




  def dump( data) when is_struct(data, __MODULE__) do

     {:ok, to_string(data)}
  end

  def dump(data) when is_nil(data) do {:ok, nil} end

  defp parse(value) when is_binary(data) do
    with  {:ok, phone_number} <- ExPhoneNumber.parse(value, nil) do
         region_code = ExPhoneNumber.Metadata.get_region_code_for_country_code(phone_number.country_code)
        {:ok,  struct(__MODULE__, country_code: region_code, national_number: phone_number.national_number)}
    end
  end

   defimpl String.Chars do
    def to_string(%{region_code: region_code, national_number: national_number}) do
      {:ok, phone_number} = ExPhoneNumber.parse(Integer.to_string(national_number), region_code)
      "+"<>number  = ExPhoneNumber.format(phone_number, :e164)
      number
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%{region_code: region_code, national_number: national_number}) do
      {:ok, phone_number} = ExPhoneNumber.parse(Integer.to_string(national_number), region_code)
      ExPhoneNumber.format(phone_number, :international)
    end
  end
end
