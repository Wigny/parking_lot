defmodule ParkingLot.ALPR.Text.Recognizer do
  @moduledoc """
  Based on https://github.com/opencv/opencv_zoo/tree/master/models/text_recognition_crnn by
  https://github.com/cocoa-xu/evision/pull/143
  """

  use GenServer
  alias Evision.Zoo.{TextDetection, TextRecognition}

  # Server

  @impl true
  def init(state) do
    {:ok, state, {:continue, :init}}
  end

  @impl true
  def handle_continue(:init, _state) do
    opts = [backend: Evision.cv_DNN_BACKEND_OPENCV(), target: Evision.cv_DNN_TARGET_CPU()]

    detector = TextDetection.DB.init(:td500_resnet18, opts)
    recognizer = TextRecognition.CRNN.init(:cn, opts)
    charset = TextRecognition.CRNN.get_charset(:cn)

    state = %{detector: detector, recognizer: recognizer, charset: charset}

    {:noreply, state}
  end

  @impl true
  def handle_call({:detect, image}, _from, state) do
    %{detector: detector} = state

    inference = TextDetection.DB.infer(detector, image)
    {:reply, inference, state}
  end

  @impl true
  def handle_call({:recognize, detection, image}, _from, state) do
    %{recognizer: recognizer, charset: charset} = state

    infer_opts = [to_gray: false, charset: charset]
    inference = TextRecognition.CRNN.infer(recognizer, image, detection, infer_opts)
    {:reply, inference, state}
  end

  # Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def infer(image) do
    image
    |> detections()
    |> filter_detections()
    |> Enum.map(fn detection -> recognitions(image, detection) end)
  end

  defp detections(image) do
    GenServer.call(__MODULE__, {:detect, image}, :infinity)
  end

  defp recognitions(image, detection) do
    GenServer.call(__MODULE__, {:recognize, detection, image})
  end

  defp filter_detections({detections, confidences}) do
    detections
    |> Enum.zip(confidences)
    |> Enum.filter(fn {_detection, confidence} -> match?(1.0, confidence) end)
    |> Enum.map(fn {detection, _confidence} -> detection end)
  end
end
