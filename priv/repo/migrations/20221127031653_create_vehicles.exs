defmodule ParkingLot.Repo.Migrations.CreateVehicles do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :license_plate, :string
      add :deleted_at, :utc_datetime

      timestamps()
    end

    create unique_index(:vehicles, [:license_plate])
  end
end
