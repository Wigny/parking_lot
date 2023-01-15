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

unless Mix.env() == :test do
  alias ParkingLot.Repo
  alias ParkingLot.Vehicles

  now = DateTime.truncate(DateTime.utc_now(), :second)

  Repo.insert_all(
    Vehicles.Color,
    [
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
    ]
  )

  Repo.insert!(%Vehicles.Brand{
    name: "HONDA",
    models: [%Vehicles.Model{name: "CG 150 TITAN ES"}]
  })

  Repo.insert!(%Vehicles.Brand{
    name: "CHEV",
    models: [%Vehicles.Model{name: "ONIX PLUS 10TAT PR2"}]
  })

  Repo.insert_all(
    Vehicles.Type,
    [
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
    ]
  )
end
