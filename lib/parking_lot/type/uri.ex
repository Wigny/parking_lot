defmodule ParkingLot.Type.URI do
  @moduledoc """
  Custom `Ecto.Type` for handling `URI` structs as binary.
  """

  use Ecto.Type

  @impl true
  def type, do: :string

  @impl true
  def cast(uri) when is_binary(uri) do
    case URI.new(uri) do
      {:ok, _uri} = ok -> ok
      {:error, _part} -> :error
    end
  end

  def cast(uri) when is_struct(uri, URI) do
    {:ok, uri}
  end

  def cast(_uri) do
    :error
  end

  @impl true
  def load(uri), do: {:ok, URI.new!(uri)}

  @impl true
  def dump(%URI{} = uri), do: {:ok, URI.to_string(uri)}
  def dump(_uri), do: :error
end
