defmodule ParkingLot.ALPR do
  @moduledoc """
  Based on https://github.com/opencv/opencv_zoo/tree/master/models/text_recognition_crnn by https://github.com/cocoa-xu/evision/pull/143
  """

  def predict(image_path) do
    image = read_image(image_path)
    {detections, confidences} = detect_text(image)

    detections
    |> Enum.zip(confidences)
    |> Enum.filter(&match?({_detection, 1.0}, &1))
    |> Enum.map(fn {detection, _confidence} -> recognize_text(image, detection) end)
  end

  defp read_image(filepath) do
    filepath
    |> Evision.imread()
    |> Evision.resize({736, 736})
  end

  defp detect_text(image) do
    alias Evision.Zoo.TextDetection.DB

    detector = DB.init(:td500_resnet18)
    DB.infer(detector, image)
  end

  defp recognize_text(image, rotation_box) do
    alias Evision.Zoo.TextRecognition.CRNN

    recognizer = CRNN.init(:cn)
    charset = CRNN.get_charset(:cn)

    CRNN.infer(recognizer, image, rotation_box, to_gray: false, charset: charset)
  end
end
