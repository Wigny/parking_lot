defmodule ParkingLot.Repo.Migrations.CreateCameras do
  use Ecto.Migration

  def change do
    create table(:cameras) do
      add :type, :string
      add :uri, :string

      timestamps type: :utc_datetime
    end

    create unique_index(:cameras, [:uri])
    create unique_index(:cameras, [:type])
  end
end
