defmodule ParkingLot.ALPR do
  @moduledoc false

  alias ParkingLot.ALPR.{Extractor, Recognizer, Video}

  def video(url), do: Video.start(url)

  def recognize_plate(video) do
    video
    |> Video.frame()
    |> Recognizer.predict()
    |> Extractor.capture()
  end
end
