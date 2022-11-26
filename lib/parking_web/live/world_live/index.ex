defmodule ParkingWeb.WorldLive.Index do
  use ParkingWeb, :live_view

  @weekdays ~w[sunday monday tuesday wednesday thursday friday saturday]

  @impl true
  def mount(_params, _session, socket) do
    today = Date.utc_today()
    day_of_week = Date.day_of_week(today, :sunday)
    weekday = Enum.at(@weekdays, day_of_week - 1)

    {:ok, assign(socket, weekday: weekday, today: today)}
  end
end
