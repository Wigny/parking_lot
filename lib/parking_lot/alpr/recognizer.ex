defmodule ParkingLot.ALPR.Recognizer do
  @moduledoc """
  Based on https://github.com/opencv/opencv_zoo/tree/master/models/text_recognition_crnn by https://github.com/cocoa-xu/evision/pull/143
  """

  alias Evision.Zoo.{TextDetection, TextRecognition}

  def predict(image) do
    image
    |> detect_text()
    |> filter_detections()
    |> Enum.map(&recognize_text(image, &1))
  end

  defp detect_text(image) do
    detector = TextDetection.DB.init(:td500_resnet18)
    TextDetection.DB.infer(detector, image)
  end

  defp recognize_text(image, detection) do
    recognizer = TextRecognition.CRNN.init(:cn)
    charset = TextRecognition.CRNN.get_charset(:cn)

    TextRecognition.CRNN.infer(recognizer, image, detection, to_gray: false, charset: charset)
  end

  defp filter_detections({detections, confidences}) do
    detections
    |> Enum.zip(confidences)
    |> Enum.filter(fn {_detection, confidence} -> match?(1.0, confidence) end)
    |> Enum.map(fn {detection, _confidence} -> detection end)
  end
end
