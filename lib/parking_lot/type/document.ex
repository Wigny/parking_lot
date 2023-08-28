defmodule ParkingLot.Type.Document do
  use Ecto.ParameterizedType

  @impl true
  def type(_params), do: {:array, :integer}

  @impl true
  def init(opts), do: %{type: opts[:as]}

  @impl true

  def cast(value, %{type: document}) when is_list(value) do
    {:ok, document.new(value)}
  end

  def cast(value, %{type: document}) when is_struct(value, document) do
    {:ok, value}
  end

  def cast(value, _params) when is_nil(value) do
    {:ok, nil}
  end

  @impl true

  def load(value, _loader, %{type: document}) when is_list(value) do
    {:ok, document.new(value)}
  end

  def load(value, _loader, _params) when is_nil(value) do
    {:ok, nil}
  end

  @impl true

  def dump(value, _dumper, %{type: document}) when is_struct(value, document) do
    {:ok, document.to_digits(value)}
  end

  def dump(value, _dumper, _params) when is_nil(value) do
    {:ok, nil}
  end
end
