defmodule ParkingLot.Repo.Migrations.AddParkingsDatetimeFields do
  use Ecto.Migration

  def change do
    alter table(:parkings) do
      add :entered_at, :utc_datetime, null: false
      add :left_at, :utc_datetime
    end
  end
end
