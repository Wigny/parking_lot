defmodule ParkingLot.Repo.Migrations.AddActiveFieldToCamerasTable do
  use Ecto.Migration

  def change do
    alter table(:cameras) do
      add :active, :boolean, default: false
    end
  end
end
