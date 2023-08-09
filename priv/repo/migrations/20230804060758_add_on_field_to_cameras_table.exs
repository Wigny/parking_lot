defmodule ParkingLot.Repo.Migrations.AddOnFieldToCamerasTable do
  use Ecto.Migration

  def change do
    alter table(:cameras) do
      add :on, :boolean, default: false
    end
  end
end
