defmodule ParkingLot.Repo.Migrations.AddVehicleTypeToModel do
  use Ecto.Migration

  def change do
    alter table(:vehicles) do
      remove :type_id
    end

    alter table(:vehicle_models) do
      add :type_id, references(:vehicle_types, on_delete: :nothing)
    end
  end
end
