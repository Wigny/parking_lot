defmodule ParkingLot.Repo.Migrations.CreateVehicleColors do
  use Ecto.Migration

  def change do
    create table(:vehicle_colors) do
      add :color, :string

      timestamps()
    end

    create unique_index(:vehicle_colors, [:color])
  end
end
