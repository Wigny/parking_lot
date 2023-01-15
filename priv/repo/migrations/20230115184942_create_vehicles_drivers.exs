defmodule ParkingLot.Repo.Migrations.CreateVehiclesDrivers do
  use Ecto.Migration

  def change do
    create table(:vehicles_drivers) do
      add :active, :boolean, default: false, null: false
      add :driver_id, references(:drivers, on_delete: :nothing)
      add :vehicle_id, references(:vehicles, on_delete: :nothing)

      timestamps()
    end

    create index(:vehicles_drivers, [:driver_id])
    create index(:vehicles_drivers, [:vehicle_id])
    create unique_index(:vehicles_drivers, [:driver_id, :vehicle_id])
  end
end
