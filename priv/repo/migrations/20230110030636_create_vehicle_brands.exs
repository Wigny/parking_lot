defmodule ParkingLot.Repo.Migrations.CreateVehicleBrands do
  use Ecto.Migration

  def change do
    create table(:vehicle_brands) do
      add :brand, :string

      timestamps()
    end

    create unique_index(:vehicle_brands, [:brand])
  end
end
