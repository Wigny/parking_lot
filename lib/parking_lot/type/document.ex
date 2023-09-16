defmodule ParkingLot.Type.Document do
  use Ecto.ParameterizedType

  alias ParkingLot.Digits

  @impl true
  def type(_params), do: :string

  @impl true
  def init(opts), do: %{type: opts[:as]}

  @impl true
  def cast(value, params) when is_binary(value) do
    digits = Digits.parse(value)
    cast(digits, params)
  end

  def cast(value, %{type: document}) when is_list(value) do
    case apply(document, :new, [value]) do
      {:ok, _document} = ok -> ok
      {:error, error} -> {:error, message: error.reason}
    end
  end

  def cast(value, %{type: document}) when is_struct(value, document) do
    {:ok, value}
  end

  def cast(value, _params) when is_nil(value) do
    {:ok, nil}
  end

  def cast(_value, _params) do
    :error
  end

  @impl true
  def load(value, _loader, %{type: document}) when is_binary(value) do
    case apply(document, :new, [Digits.parse(value)]) do
      {:ok, _document} = ok -> ok
      {:error, _error} -> :error
    end
  end

  def load(value, _loader, _params) when is_nil(value) do
    {:ok, nil}
  end

  @impl true
  def dump(value, _dumper, %{type: document}) when is_struct(value, document) do
    digits = apply(document, :to_digits, [value])
    {:ok, Digits.to_string(digits)}
  end

  def dump(value, _dumper, _params) when is_nil(value) do
    {:ok, nil}
  end

  def dump(_value, _dumper, _params) do
    :error
  end
end
