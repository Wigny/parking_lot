defmodule ParkingLot.Type.URI do
  @moduledoc """
  Custom Ecto Type for handling `URI` structs in schema fields
  """

  use Ecto.Type

  def type, do: :string

  def cast(uri) do
    case URI.new(uri) do
      {:ok, uri} -> {:ok, uri}
      {:error, _error} -> :error
    end
  end

  def load(uri), do: URI.new(uri)

  def dump(%URI{} = uri), do: {:ok, URI.to_string(uri)}
  def dump(_), do: :error

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%URI{} = uri), do: URI.to_string(uri)
  end
end
