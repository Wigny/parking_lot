defmodule ParkingLot.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :email, :citext, null: false
      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:user_sessions) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      timestamps(updated_at: false)
    end

    create index(:user_sessions, [:user_id])
    create unique_index(:user_sessions, [:token])
  end
end
