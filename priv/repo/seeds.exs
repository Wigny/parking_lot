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

  Enum.map(
    [
      "Amarelo",
      "Azul",
      "Bege",
      "Branca",
      "Cinza",
      "Dourada",
      "Grená",
      "Laranja",
      "Marrom",
      "Prata",
      "Preta",
      "Rosa",
      "Roxa",
      "Verde",
      "Vermelha",
      "Fantasia"
    ],
    fn color ->
      %Vehicles.Color{}
      |> Vehicles.change_color(%{name: color})
      |> Repo.insert!()
    end
  )

  Enum.map(
    [
      "Automóvel",
      "Caminhão",
      "Caminhão Trator",
      "Caminhonete",
      "Camioneta",
      "Carga",
      "Chassi Plataforma",
      "Ciclomotor",
      "Especial",
      "Micro-Ônibus",
      "Motocicleta",
      "Motoneta",
      "Motor-Casa",
      "Ônibus",
      "Quadriciclo",
      "Reboque",
      "Semirreboque",
      "Tr Esteiras",
      "Tr Misto",
      "Tr Rodas",
      "Triciclo",
      "Utilitário"
    ],
    fn type ->
      %Vehicles.Type{}
      |> Vehicles.change_type(%{name: type})
      |> Repo.insert!()
    end
  )
end
