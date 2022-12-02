defmodule ParkingWeb.PageLive.Index do
  use ParkingWeb, :live_view
  import Parking.ALPR, only: [recognize: 1]
  alias Parking.ALPR.State

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, plate: nil, vehicles: State.list())}
  end

  @impl true
  def handle_event("video_snapshot", snapshot, socket) do
    send(self(), {:recognize, snapshot})

    {:noreply, socket}
  end

  @impl true
  def handle_info({:recognize, snapshot}, socket) do
    [_start, raw] = String.split(snapshot, ";base64,")

    raw
    |> recognize()
    |> register(socket)
  end

  defp register({:ok, plate}, socket) do
    now = DateTime.utc_now()
    last_vehicle = State.last()

    IO.inspect({last_vehicle.license_plate, plate}, label: :plates)

    # if not is_nil(last_vehicle) and in_delta?(now, last_vehicle.inserted_at, :timer.minutes(2)) do
    # {:noreply, socket}
    # else
    # State.insert(%{license_plate: plate, inserted_at: now})
    {:noreply, assign(socket, :plate, plate)}
    # end
  end

  defp register({:error, _error}, socket) do
    {:noreply, socket}
  end

  defp in_delta?(dt1, dt2, delta) do
    unix1 = DateTime.to_unix(dt1)
    unix2 = DateTime.to_unix(dt2)
    diff = abs(unix1 - unix2)

    diff <= delta
  end
end
