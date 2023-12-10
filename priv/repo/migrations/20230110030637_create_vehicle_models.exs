defmodule ParkingLot.Repo.Migrations.CreateVehicleModels do
  use Ecto.Migration

  def change do
    create table(:vehicle_models) do
      add :name, :string
      add :brand_id, references(:vehicle_brands, on_delete: :nothing)

      timestamps type: :utc_datetime
    end

    create unique_index(:vehicle_models, [:name])
    create index(:vehicle_models, [:brand_id])
  end
end
