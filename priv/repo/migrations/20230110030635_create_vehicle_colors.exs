defmodule ParkingLot.Repo.Migrations.CreateVehicleColors do
  use Ecto.Migration

  def change do
    create table(:vehicle_colors) do
      add :name, :string

      timestamps type: :utc_datetime
    end

    create unique_index(:vehicle_colors, [:name])

    flush()

    execute(fn ->
      now = DateTime.utc_now()

      repo().insert_all("vehicle_colors", [
        %{name: "Amarelo", inserted_at: now, updated_at: now},
        %{name: "Azul", inserted_at: now, updated_at: now},
        %{name: "Bege", inserted_at: now, updated_at: now},
        %{name: "Branca", inserted_at: now, updated_at: now},
        %{name: "Cinza", inserted_at: now, updated_at: now},
        %{name: "Dourada", inserted_at: now, updated_at: now},
        %{name: "Grená", inserted_at: now, updated_at: now},
        %{name: "Laranja", inserted_at: now, updated_at: now},
        %{name: "Marrom", inserted_at: now, updated_at: now},
        %{name: "Prata", inserted_at: now, updated_at: now},
        %{name: "Preta", inserted_at: now, updated_at: now},
        %{name: "Rosa", inserted_at: now, updated_at: now},
        %{name: "Roxa", inserted_at: now, updated_at: now},
        %{name: "Verde", inserted_at: now, updated_at: now},
        %{name: "Vermelha", inserted_at: now, updated_at: now},
        %{name: "Fantasia", inserted_at: now, updated_at: now}
      ])
    end)
  end
end
