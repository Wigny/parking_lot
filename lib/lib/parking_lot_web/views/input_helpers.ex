defmodule ParkingLotWeb.InputHelpers do
  @moduledoc """
  Custom form inputs
  """

  use Phoenix.HTML

  def numeric_input(form, field, opts \\ []) do
    opts = Keyword.merge(opts, inputmode: "numeric", pattern: "[0-9]*", phx_hook: "NumericInput")

    text_input(form, field, opts)
  end

  def select_input(form, field, options, opts \\ []) do
    listname = "#{input_id(form, field)}_list"

    [
      text_input(form, field, Keyword.put(opts, :list, listname)),
      content_tag(:datalist, [id: listname], do: options_for_select(options, opts[:selected]))
    ]
  end
end
