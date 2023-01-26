defmodule ParkingLot.ALPR.Recognizer do
  @moduledoc """
  Based on https://github.com/opencv/opencv_zoo/tree/master/models/text_recognition_crnn by
  https://github.com/cocoa-xu/evision/pull/143
  """

  use GenServer
  alias Evision.Zoo.{TextDetection, TextRecognition}

  # Server

  @impl true
  def init(config) do
    {:ok, config, {:continue, :init}}
  end

  @impl true
  def handle_continue(:init, %{models: models, charset: charset}) do
    detector = TextDetection.DB.init(models[:detector])
    recognizer = TextRecognition.CRNN.init(models[:recognizer])
    charset = TextRecognition.CRNN.get_charset(charset)

    {:noreply, %{detector: detector, recognizer: recognizer, charset: charset}}
  end

  @impl true
  def handle_call({:detect_text, image}, _from, state) do
    %{detector: detector} = state

    inference = TextDetection.DB.infer(detector, image)
    {:reply, inference, state}
  end

  @impl true
  def handle_call({:recognize_text, detection, image}, _from, state) do
    %{recognizer: recognizer, charset: charset} = state

    infer_opts = [to_gray: false, charset: charset]
    inference = TextRecognition.CRNN.infer(recognizer, image, detection, infer_opts)
    {:reply, inference, state}
  end

  # Client

  def start_link(_opts) do
    config = %{
      models: %{detector: :td500_resnet18, recognizer: :cn},
      charset: :cn
    }

    GenServer.start_link(__MODULE__, config, name: __MODULE__)
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
