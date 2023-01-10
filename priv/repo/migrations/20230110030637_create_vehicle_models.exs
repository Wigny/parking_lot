defmodule ParkingLot.Repo.Migrations.CreateVehicleModels do
  use Ecto.Migration

  def change do
    create table(:vehicle_models) do
      add :model, :string
      add :brand_id, references(:vehicle_brands, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:vehicle_models, [:model])
    create index(:vehicle_models, [:brand_id])
  end
end
