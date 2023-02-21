defmodule ParkingLotWeb.InputHelpers do
  @moduledoc """
  Custom form inputs
  """

  use Phoenix.HTML

  def numeric_input(form, field, opts \\ []) do
    opts = Keyword.merge(opts, inputmode: "numeric", pattern: "[0-9]*", phx_hook: "NumericInput")

    text_input(form, field, opts)
  end
end
