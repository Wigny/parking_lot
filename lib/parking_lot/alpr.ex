defmodule ParkingLot.ALPR do
  @moduledoc false

  alias ParkingLot.ALPR.{Extractor, Recognizer, Video}

  def video(url), do: Video.start(url)

  def recognize(video) do
    video
    |> Video.frame()
    |> Recognizer.infer()
    |> Extractor.capture()
  end
end
