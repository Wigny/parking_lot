defmodule ParkingLot.Repo do
  use Ecto.Repo,
    otp_app: :parking_lot,
    adapter: Ecto.Adapters.Postgres
end
