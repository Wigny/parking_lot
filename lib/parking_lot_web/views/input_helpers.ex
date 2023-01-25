defmodule ParkingLotWeb.InputHelpers do
  @moduledoc """
  Custom form inputs
  """

  use Phoenix.HTML

  def uri_input(form, field, opts \\ []) do
    value = Keyword.get(opts, :value, input_value(form, field))
    opts = Keyword.put(opts, :value, uri_input_value(value))

    url_input(form, field, opts)
  end

  def numeric_input(form, field, opts \\ []) do
    opts = Keyword.merge(opts, inputmode: "numeric", pattern: "[0-9]*", phx_hook: "NumericInput")

    text_input(form, field, opts)
  end

  defp uri_input_value(%URI{} = uri), do: URI.to_string(uri)
  defp uri_input_value(other), do: other
end
