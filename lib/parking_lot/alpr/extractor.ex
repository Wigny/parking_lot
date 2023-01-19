defmodule ParkingLot.ALPR.Extractor do
  @moduledoc false

  @license_plate_regex ~r/(?<legacy>[A-Z]{3}-?[0-9]{4})|(?<mercosul>[A-Z]{3}[0-9][A-Z][0-9]{2})/

  def capture(recognitions) when is_list(recognitions) do
    Enum.map(recognitions, &capture/1)
  end

  def capture(recognition) when is_binary(recognition) do
    @license_plate_regex
    |> Regex.run(recognition)
    |> List.wrap()
    |> List.first()
  end
end
