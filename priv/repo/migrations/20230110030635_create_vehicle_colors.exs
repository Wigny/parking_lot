defmodule ParkingLot.Repo.Migrations.CreateVehicleColors do
  use Ecto.Migration

  def change do
    create table(:vehicle_colors) do
      add :name, :string

      timestamps()
    end

    create unique_index(:vehicle_colors, [:name])
  end
end
