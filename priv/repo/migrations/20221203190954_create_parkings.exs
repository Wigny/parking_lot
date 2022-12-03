defmodule ParkingLot.Repo.Migrations.CreateParkings do
  use Ecto.Migration

  def change do
    create table(:parkings) do
      add :vehicle_id, references(:vehicles, on_delete: :nothing)

      timestamps()
    end

    create index(:parkings, [:vehicle_id])
  end
end
