defmodule Parking.Repo do
  use Ecto.Repo,
    otp_app: :parking,
    adapter: Ecto.Adapters.Postgres
end
