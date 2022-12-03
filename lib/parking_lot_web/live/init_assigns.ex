defmodule ParkingLotWeb.InitAssigns do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """

  import Phoenix.LiveView
  import Phoenix.Component

  @default_locale "en"
  @default_timezone "UTC"

  def on_mount(:default, _params, _session, socket) do
    assigns = [
      locale: get_connect_params(socket)["locale"] || @default_locale,
      timezone: get_connect_params(socket)["timezone"] || @default_timezone
    ]

    {:cont, assign(socket, assigns)}
  end
end
