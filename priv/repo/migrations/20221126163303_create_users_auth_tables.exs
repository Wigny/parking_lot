defmodule ParkingLot.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])

    create table(:sessions) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      timestamps(updated_at: false)
    end

    create index(:sessions, [:user_id])
    create unique_index(:sessions, [:token])
  end
end
