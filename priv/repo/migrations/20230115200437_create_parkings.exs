defmodule ParkingLot.Repo.Migrations.CreateParkings do
  use Ecto.Migration

  def change do
    create table(:parkings) do
      add :vehicle_id, references(:vehicles, on_delete: :nothing)
      add :entered_at, :utc_datetime, null: false
      add :left_at, :utc_datetime

      timestamps()
    end

    create index(:parkings, [:vehicle_id])
  end
end
