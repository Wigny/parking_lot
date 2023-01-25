defmodule ParkingLot.ALPR do
  @moduledoc false

  alias ParkingLot.ALPR.{Extractor, Recognizer, Video}

  def video(uri), do: Video.start_link(uri)

  def recognize(video) do
    video
    |> Video.frame()
    |> Recognizer.infer()
    |> Extractor.capture()
  end
end
