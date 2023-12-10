defmodule ParkingLot.Repo.Migrations.CreateVehicleBrands do
  use Ecto.Migration

  def change do
    create table(:vehicle_brands) do
      add :name, :string

      timestamps type: :utc_datetime
    end

    create unique_index(:vehicle_brands, [:name])
  end
end
