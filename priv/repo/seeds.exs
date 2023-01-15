# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ParkingLot.Repo.insert!(%ParkingLot.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ParkingLot.Repo
alias ParkingLot.Vehicles

now = DateTime.truncate(DateTime.utc_now(), :second)

Repo.insert_all(
  Vehicles.Color,
  [
    %{color: "Amarelo", inserted_at: now, updated_at: now},
    %{color: "Azul", inserted_at: now, updated_at: now},
    %{color: "Bege", inserted_at: now, updated_at: now},
    %{color: "Branca", inserted_at: now, updated_at: now},
    %{color: "Cinza", inserted_at: now, updated_at: now},
    %{color: "Dourada", inserted_at: now, updated_at: now},
    %{color: "Grená", inserted_at: now, updated_at: now},
    %{color: "Laranja", inserted_at: now, updated_at: now},
    %{color: "Marrom", inserted_at: now, updated_at: now},
    %{color: "Prata", inserted_at: now, updated_at: now},
    %{color: "Preta", inserted_at: now, updated_at: now},
    %{color: "Rosa", inserted_at: now, updated_at: now},
    %{color: "Roxa", inserted_at: now, updated_at: now},
    %{color: "Verde", inserted_at: now, updated_at: now},
    %{color: "Vermelha", inserted_at: now, updated_at: now},
    %{color: "Fantasia", inserted_at: now, updated_at: now}
  ]
)

Repo.insert!(%Vehicles.Brand{
  brand: "HONDA",
  models: [%Vehicles.Model{model: "CG 150 TITAN ES"}]
})

Repo.insert!(%Vehicles.Brand{
  brand: "CHEV",
  models: [%Vehicles.Model{model: "ONIX PLUS 10TAT PR2"}]
})

Repo.insert_all(
  Vehicles.Type,
  [
    %{type: "Automóvel", inserted_at: now, updated_at: now},
    %{type: "Caminhão", inserted_at: now, updated_at: now},
    %{type: "Caminhão Trator", inserted_at: now, updated_at: now},
    %{type: "Caminhonete", inserted_at: now, updated_at: now},
    %{type: "Camioneta", inserted_at: now, updated_at: now},
    %{type: "Carga", inserted_at: now, updated_at: now},
    %{type: "Chassi Plataforma", inserted_at: now, updated_at: now},
    %{type: "Ciclomotor", inserted_at: now, updated_at: now},
    %{type: "Especial", inserted_at: now, updated_at: now},
    %{type: "Micro-Ônibus", inserted_at: now, updated_at: now},
    %{type: "Motocicleta", inserted_at: now, updated_at: now},
    %{type: "Motoneta", inserted_at: now, updated_at: now},
    %{type: "Motor-Casa", inserted_at: now, updated_at: now},
    %{type: "Ônibus", inserted_at: now, updated_at: now},
    %{type: "Quadriciclo", inserted_at: now, updated_at: now},
    %{type: "Reboque", inserted_at: now, updated_at: now},
    %{type: "Semirreboque", inserted_at: now, updated_at: now},
    %{type: "Tr Esteiras", inserted_at: now, updated_at: now},
    %{type: "Tr Misto", inserted_at: now, updated_at: now},
    %{type: "Tr Rodas", inserted_at: now, updated_at: now},
    %{type: "Triciclo", inserted_at: now, updated_at: now},
    %{type: "Utilitário", inserted_at: now, updated_at: now}
  ]
)
