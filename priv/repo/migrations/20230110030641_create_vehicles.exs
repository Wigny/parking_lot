defmodule ParkingLot.Repo.Migrations.CreateVehicles do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :license_plate, :string
      add :active, :boolean, default: false, null: true
      add :type_id, references(:vehicle_types, on_delete: :nothing)
      add :model_id, references(:vehicle_models, on_delete: :nothing)
      add :color_id, references(:vehicle_colors, on_delete: :nothing)

      timestamps type: :utc_datetime
    end

    create unique_index(:vehicles, [:license_plate])
    create index(:vehicles, [:type_id])
    create index(:vehicles, [:model_id])
    create index(:vehicles, [:color_id])
  end
end
