defmodule ParkingLot.Type.URI do
  @moduledoc """
  Custom Ecto Type for handling `URI` structs in schema fields
  """

  use Ecto.Type

  def type, do: :string

  def cast(uri) do
    with {:error, _error} <- URI.new(uri), do: :error
  end

  def load(uri), do: URI.new(uri)

  def dump(%URI{} = uri), do: {:ok, URI.to_string(uri)}
  def dump(_uri), do: :error
end
