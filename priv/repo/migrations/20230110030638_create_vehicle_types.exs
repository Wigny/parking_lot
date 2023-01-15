defmodule ParkingLot.Repo.Migrations.CreateVehicleTypes do
  use Ecto.Migration

  def change do
    create table(:vehicle_types) do
      add :name, :string

      timestamps()
    end

    create unique_index(:vehicle_types, [:name])
  end
end
