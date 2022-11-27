defmodule ParkingWeb.WorldLive.Index do
  use ParkingWeb, :live_view

  alias Parking.Accounts

  @weekdays ~w[sunday monday tuesday wednesday thursday friday saturday]

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    today = Date.utc_today()
    day_of_week = Date.day_of_week(today, :sunday)
    weekday = Enum.at(@weekdays, day_of_week - 1)

    {:ok, assign(socket, weekday: weekday, today: today, current_user: user)}
  end
end
