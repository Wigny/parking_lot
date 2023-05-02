defmodule ParkingLot.Repo.Migrations.CreateDrivers do
  use Ecto.Migration

  def change do
    create table(:drivers) do
      add :name, :string
      add :cpf, :string
      add :cnh, :string
      add :email, :string
      add :phone, :string
      add :active, :boolean, default: false, null: true

      timestamps()
    end

    create unique_index(:drivers, [:phone])
    create unique_index(:drivers, [:email])
    create unique_index(:drivers, [:cnh])
    create unique_index(:drivers, [:cpf])
  end
end
