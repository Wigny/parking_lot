defmodule ParkingLot.Phone do
  @moduledoc """
  A representation of a phone number.

  This module is a tiny wrapper around the `ExPhoneNumber` library, providing a clear and simple
  API to deal with creating, parsing and validating phone numbers.
  """

  alias ExPhoneNumber.Model.PhoneNumber

  @type t :: %__MODULE__{code: non_neg_integer, number: non_neg_integer}
  defstruct [:code, :number]

  defmodule Error do
    @moduledoc false

    alias ExPhoneNumber.Constants.ErrorMessages

    @reasons_messages [
      {"invalid country code", ErrorMessages.invalid_country_code()},
      {"not a number", ErrorMessages.not_a_number()},
      {"too short after IDD", ErrorMessages.too_short_after_idd()},
      {"too short", ErrorMessages.too_short_nsn()},
      {"too long", ErrorMessages.too_long()},
      {"invalid length", "The phone number has not a valid length"}
    ]

    @type t :: %__MODULE__{reason: binary}
    defexception [:reason]

    def new(fields), do: struct!(__MODULE__, fields)

    for {reason, message} <- @reasons_messages do
      def exception(unquote(message)), do: new(reason: unquote(reason))

      def message(%__MODULE__{reason: unquote(reason)}), do: unquote(message)
    end
  end

  @doc """
  Similar to `new/2`, but expects a E-164 number as parameter instead of a pair of local number
  and country code.

  ## Examples

      iex> ParkingLot.Phone.new("+44 (020) 1234 5678")
      {:ok, %ParkingLot.Phone{code: 44, number: 02012345678}}

      iex> ParkingLot.Phone.new("+55 9876")
      {:error, %ParkingLot.Phone.Error{reason: "too short"}}
  """
  @spec new(number :: binary) :: {:ok, t} | {:error, Error.t()}
  def new(<<?+, _e164::binary>> = number) do
    new(number, nil)
  end

  @doc """
  Creates a new `ParkingLot.Phone` struct from given local number and country code.

  ## Examples

      iex> ParkingLot.Phone.new("(11) 98765-4321", "BR")
      {:ok, %ParkingLot.Phone{code: 55, number: 11987654321}}

      iex> ParkingLot.Phone.new("9876", "BR")
      {:error, %ParkingLot.Phone.Error{reason: "too short"}}
  """
  @spec new(number :: binary, country :: binary | nil) :: {:ok, t} | {:error, Error.t()}
  def new(number, country) do
    with {:ok, phone} <- parse(number, country),
         :ok <- validate_number_possible(phone),
         :ok <- validate_match_country(phone, country) do
      {:ok, phone}
    end
  end

  @doc """
  Same as `new/1`, but raises an exception if the phone number is invalid.

  ## Examples

      iex> ParkingLot.Phone.new!("+44 (020) 1234 5678")
      %ParkingLot.Phone{code: 44, number: 02012345678}

      iex> ParkingLot.Phone.new!("+55 9876")
      ** (ParkingLot.Phone.Error) The string supplied is too short to be a phone number
  """
  @spec new!(number :: binary) :: t
  def new!(<<?+, _e164::binary>> = number) do
    new!(number, nil)
  end

  @doc """
  Same as `new/2`, but raises an exception if the phone number is invalid.

  ## Examples

      iex> ParkingLot.Phone.new!("(11) 98765-4321", "BR")
      %ParkingLot.Phone{code: 55, number: 11987654321}

      iex> ParkingLot.Phone.new!("invalid", "BR")
      ** (ParkingLot.Phone.Error) The string supplied did not seem to be a phone number
  """
  @spec new!(number :: binary, country :: binary | nil) :: t
  def new!(number, country) do
    case new(number, country) do
      {:ok, phone} -> phone
      {:error, error} -> raise error
    end
  end

  @doc """
  Parses a phone number and country code into the `ParkingLot.Phone` struct without futher
  validations.
  """
  @spec parse(number :: binary, country :: binary | nil) :: {:ok, t} | {:error, Error.t()}
  def parse(number, country \\ nil) do
    case ExPhoneNumber.parse(number, country) do
      {:ok, phone_number} ->
        {:ok, %__MODULE__{code: phone_number.country_code, number: phone_number.national_number}}

      {:error, message} ->
        {:error, Error.exception(message)}
    end
  end

  @doc """
  Checks whether the `ParkingLot.Phone` has a possible valid number.

  ## Examples

      iex> {:ok, phone} = ParkingLot.Phone.parse("+800 1234 5678")
      iex> ParkingLot.Phone.valid?(phone)
      true

      iex> {:ok, phone} = ParkingLot.Phone.parse("9876", "BR")
      iex> ParkingLot.Phone.valid?(phone)
      false
  """
  @spec valid?(phone :: t) :: boolean
  def valid?(phone) do
    phone_number = %PhoneNumber{country_code: phone.code, national_number: phone.number}

    ExPhoneNumber.is_possible_number?(phone_number) and
      ExPhoneNumber.is_valid_number?(phone_number)
  end

  @doc """
  Converts the `ParkingLot.Phone` into its phone number representation.

  ## Examples

      iex> phone = ParkingLot.Phone.new!("+55 11 98765-4321")
      iex> ParkingLot.Phone.to_number(phone)
      "+5511987654321"
  """
  @spec to_number(phone :: t) :: binary
  def to_number(phone) do
    phone_number = %PhoneNumber{country_code: phone.code, national_number: phone.number}

    ExPhoneNumber.format(phone_number, :e164)
  end

  @doc """
  Converts the `ParkingLot.Phone` into a formatted phone number string.

  ## Examples

      iex> phone = ParkingLot.Phone.new!("11987654321", "BR")
      iex> ParkingLot.Phone.to_string(phone)
      "+55 11 98765-4321"
  """
  @spec to_string(phone :: t) :: binary
  def to_string(phone) do
    phone_number = %PhoneNumber{country_code: phone.code, national_number: phone.number}

    ExPhoneNumber.format(phone_number, :international)
  end

  @doc """
  Converts the given `ParkingLot.Phone` into the `URI` struct.

  ## Examples

      iex> phone = ParkingLot.Phone.new!("+55 11 98765-4321")
      iex> ParkingLot.Phone.to_uri(phone)
      %URI{scheme: "tel", path: "+55-11-98765-4321"}
  """
  @spec to_uri(phone :: t) :: URI.t()
  def to_uri(phone) do
    phone_number = %PhoneNumber{country_code: phone.code, national_number: phone.number}

    tel = ExPhoneNumber.format(phone_number, :rfc3966)
    URI.parse(tel)
  end

  defp validate_number_possible(phone) do
    phone_number = %PhoneNumber{country_code: phone.code, national_number: phone.number}

    case ExPhoneNumber.Validation.is_possible_number_with_reason?(phone_number) do
      :is_possible -> :ok
      :invalid_country_code -> {:error, Error.new(reason: "invalid country code")}
      :too_short -> {:error, Error.new(reason: "too short")}
      :too_long -> {:error, Error.new(reason: "too long")}
      :invalid_length -> {:error, Error.new(reason: "invalid length")}
    end
  end

  defp validate_match_country(_phone, nil) do
    :ok
  end

  defp validate_match_country(phone, country) do
    if match?(^country, ExPhoneNumber.Metadata.get_region_code_for_country_code(phone.code)) do
      :ok
    else
      {:error, Error.new(reason: "invalid country code")}
    end
  end

  defimpl String.Chars do
    defdelegate to_string(phone), to: ParkingLot.Phone
  end

  defimpl Inspect do
    def inspect(phone, _opts) do
      Inspect.Algebra.concat(["#ParkingLot.Phone<", to_string(phone), ">"])
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(phone) do
      to_string(phone)
    end
  end
end
