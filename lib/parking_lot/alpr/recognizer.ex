defmodule ParkingLot.ALPR.Recognizer do
  @moduledoc """
  Based on https://github.com/opencv/opencv_zoo/tree/master/models/text_recognition_crnn by
  https://github.com/cocoa-xu/evision/pull/143
  """

  use GenServer
  import Evision.Constant
  alias Evision.Zoo.{TextDetection, TextRecognition}

  # Client

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def infer(%{shape: {height, width, _channels}} = image) do
    resized_image = Evision.resize(image, {736, 736})

    {detections, _confidences} = detect_text(resized_image)
    recognitions = Enum.map(detections, &recognize_text(resized_image, &1))

    detections =
      Enum.map(detections, fn points ->
        Nx.as_type(
          Nx.multiply(
            Evision.Mat.to_nx(Evision.boxPoints(points), Nx.BinaryBackend),
            Nx.tensor([width / 736, height / 736], backend: Nx.BinaryBackend)
          ),
          :s32
        )
      end)

    Enum.zip(recognitions, detections)
  end

  def detect_text(image) do
    GenServer.call(__MODULE__, {:detect, image}, :infinity)
  end

  def recognize_text(image, detection) do
    GenServer.call(__MODULE__, {:recognize, detection, image})
  end

  # Server

  @impl true
  def init(_state) do
    {:ok, nil, {:continue, :init}}
  end

  @impl true
  def handle_continue(:init, nil) do
    opts = [backend: cv_DNN_BACKEND_CUDA(), target: cv_DNN_TARGET_CUDA()]

    detector = TextDetection.DB.init(:td500_resnet18, opts)
    recognizer = TextRecognition.CRNN.init(:ch, opts)

    {:noreply, %{detector: detector, recognizer: recognizer}}
  end

  @impl true
  def handle_call({:detect, image}, _from, %{detector: detector} = state) do
    inference = TextDetection.DB.infer(detector, image)

    {:reply, inference, state}
  end

  @impl true
  def handle_call({:recognize, detection, image}, _from, %{recognizer: recognizer} = state) do
    opts = [to_gray: false, charset: TextRecognition.CRNN.get_charset(:ch)]

    inference = TextRecognition.CRNN.infer(recognizer, image, detection, opts)

    {:reply, inference, state}
  end
end
