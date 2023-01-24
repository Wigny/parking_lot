defmodule ParkingLot.ALPR.Recognizer do
  @moduledoc """
  Based on https://github.com/opencv/opencv_zoo/tree/master/models/text_recognition_crnn by
  https://github.com/cocoa-xu/evision/pull/143
  """

  use GenServer
  alias Evision.Zoo.{TextDetection, TextRecognition}

  @impl true
  def init(config) do
    {:ok, config}
  end

  @impl true
  def handle_call({:detect_text, image}, _from, config) do
    %{detector: detector} = config

    inference = TextDetection.DB.infer(detector, image)
    {:reply, inference, config}
  end

  @impl true
  def handle_call({:recognize_text, detection, image}, _from, config) do
    %{recognizer: recognizer, charset: charset} = config

    infer_opts = [to_gray: false, charset: charset]
    inference = TextRecognition.CRNN.infer(recognizer, image, detection, infer_opts)

    {:reply, inference, config}
  end

  def start_link(_opts) do
    detector = TextDetection.DB.init(:td500_resnet18)
    recognizer = TextRecognition.CRNN.init(:cn)
    charset = TextRecognition.CRNN.get_charset(:cn)

    config = %{detector: detector, recognizer: recognizer, charset: charset}
    opts = [name: __MODULE__]

    GenServer.start_link(__MODULE__, config, opts)
  end

  def infer(image) do
    image
    |> detections()
    |> filter_detections()
    |> Enum.map(fn detection -> recognitions(image, detection) end)
  end

  defp detections(image) do
    GenServer.call(__MODULE__, {:detect_text, image})
  end

  defp recognitions(image, detection) do
    GenServer.call(__MODULE__, {:recognize_text, detection, image})
  end

  defp filter_detections({detections, confidences}) do
    detections
    |> Enum.zip(confidences)
    |> Enum.filter(fn {_detection, confidence} -> match?(1.0, confidence) end)
    |> Enum.map(fn {detection, _confidence} -> detection end)
  end
end
