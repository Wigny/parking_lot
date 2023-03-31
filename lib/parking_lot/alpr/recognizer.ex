defmodule ParkingLot.ALPR.Recognizer do
  @moduledoc """
  Based on https://github.com/opencv/opencv_zoo/tree/master/models/text_recognition_crnn by
  https://github.com/cocoa-xu/evision/pull/143
  """

  use GenServer
  alias Evision.Zoo.{TextDetection, TextRecognition}

  # Client

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def infer(%{shape: {height, width, _channels}} = image) do
    resized_image = Evision.resize(image, {736, 736})

    {detections, confidences} = GenServer.call(__MODULE__, {:detect, resized_image}, :infinity)

    recognitions =
      Enum.map(detections, &GenServer.call(__MODULE__, {:recognize, &1, resized_image}))

    detections =
      Enum.map(detections, fn points ->
        Nx.multiply(
          Evision.Mat.to_nx(Evision.boxPoints(points), Nx.BinaryBackend),
          Nx.tensor([width / 736, height / 736], backend: Nx.BinaryBackend)
        )
        |> Nx.as_type(:s32)
      end)

    preview = TextRecognition.CRNN.visualize(image, recognitions, detections, confidences)

    {recognitions, preview}
  end

  # Server

  @impl true
  def init(_state) do
    models = %{text_detection: :td500_resnet18, text_recognition: :cn, charset: :cn}

    {:ok, models, {:continue, :init}}
  end

  @impl true
  def handle_continue(:init, models) do
    detector = TextDetection.DB.init(models.text_detection)
    recognizer = TextRecognition.CRNN.init(models.text_recognition)
    charset = TextRecognition.CRNN.get_charset(models.charset)

    {:noreply, %{detector: detector, recognizer: recognizer, charset: charset}}
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
end
