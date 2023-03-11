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
  alias Ecto.Multi
  alias ParkingLot.Repo
  alias ParkingLot.Vehicles

  insert_all = fn name, enumerable, change_fun ->
    enumerable
    |> Enum.with_index()
    |> Enum.reduce(Multi.new(), fn {elem, index}, multi ->
      Multi.insert(multi, {name, index}, then(elem, change_fun))
    end)
    |> Repo.transaction()
  end

  apply(insert_all, [
    :vehicle_colors,
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
    &Vehicles.change_color(%Vehicles.Color{}, %{name: &1})
  ])

  apply(insert_all, [
    :vehicle_types,
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
    &Vehicles.change_type(%Vehicles.Type{}, %{name: &1})
  ])
end
