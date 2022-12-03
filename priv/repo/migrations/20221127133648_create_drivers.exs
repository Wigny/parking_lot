defmodule ParkingLot.Repo.Migrations.CreateDrivers do
  use Ecto.Migration

  def change do
    create table(:drivers) do
      add :name, :string
      add :cpf, :string
      add :cnh, :string
      add :deleted_at, :utc_datetime

      timestamps()
    end

    create unique_index(:drivers, [:cnh])
    create unique_index(:drivers, [:cpf])
  end
end
