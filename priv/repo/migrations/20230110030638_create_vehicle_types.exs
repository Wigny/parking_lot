defmodule ParkingLot.Repo.Migrations.CreateVehicleTypes do
  use Ecto.Migration

  def change do
    create table(:vehicle_types) do
      add :name, :string

      timestamps type: :utc_datetime
    end

    create unique_index(:vehicle_types, [:name])

    flush()

    execute(fn ->
      now = DateTime.utc_now()

      repo().insert_all("vehicle_types", [
        %{name: "Automóvel", inserted_at: now, updated_at: now},
        %{name: "Caminhão", inserted_at: now, updated_at: now},
        %{name: "Caminhão Trator", inserted_at: now, updated_at: now},
        %{name: "Caminhonete", inserted_at: now, updated_at: now},
        %{name: "Camioneta", inserted_at: now, updated_at: now},
        %{name: "Carga", inserted_at: now, updated_at: now},
        %{name: "Chassi Plataforma", inserted_at: now, updated_at: now},
        %{name: "Ciclomotor", inserted_at: now, updated_at: now},
        %{name: "Especial", inserted_at: now, updated_at: now},
        %{name: "Micro-Ônibus", inserted_at: now, updated_at: now},
        %{name: "Motocicleta", inserted_at: now, updated_at: now},
        %{name: "Motoneta", inserted_at: now, updated_at: now},
        %{name: "Motor-Casa", inserted_at: now, updated_at: now},
        %{name: "Ônibus", inserted_at: now, updated_at: now},
        %{name: "Quadriciclo", inserted_at: now, updated_at: now},
        %{name: "Reboque", inserted_at: now, updated_at: now},
        %{name: "Semirreboque", inserted_at: now, updated_at: now},
        %{name: "Tr Esteiras", inserted_at: now, updated_at: now},
        %{name: "Tr Misto", inserted_at: now, updated_at: now},
        %{name: "Tr Rodas", inserted_at: now, updated_at: now},
        %{name: "Triciclo", inserted_at: now, updated_at: now},
        %{name: "Utilitário", inserted_at: now, updated_at: now}
      ])
    end)
  end
end
