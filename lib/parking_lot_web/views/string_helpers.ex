defmodule ParkingLotWeb.StringHelpers do
  @moduledoc false

  def mask(value, pattern, acc \\ "")

  def mask(<<>>, _pattern, acc) do
    acc
  end

  def mask(<<v, value::binary>>, <<p::binary-size(1), pattern::binary>>, acc) when p in ~w[0 a] do
    mask(value, pattern, <<acc::binary, v>>)
  end

  def mask(value, <<p, pattern::binary>>, acc) do
    mask(value, pattern, <<acc::binary, p>>)
  end
end
