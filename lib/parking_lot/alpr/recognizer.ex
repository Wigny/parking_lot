defmodule ParkingLot.ALPR.Recognizer do
  @moduledoc """
  Based on https://github.com/opencv/opencv_zoo/tree/master/models/text_recognition_crnn by
  https://github.com/cocoa-xu/evision/pull/143
  """

  use GenServer
  alias Evision.Zoo.{TextDetection, TextRecognition}

  # Server

  @impl true
  def init(_state) do
    {:ok, nil, {:continue, :init}}
  end

  @impl true
  def handle_continue(:init, _state) do
    detector = TextDetection.DB.init(:td500_resnet18)
    recognizer = TextRecognition.CRNN.init(:cn)
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

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def infer(image) do
    {detections, confidences} = GenServer.call(__MODULE__, {:detect, image}, :infinity)
    texts = Enum.map(detections, &GenServer.call(__MODULE__, {:recognize, &1, image}))

    detections =
      Enum.map(detections, fn points ->
        %{shape: {height, width, _channels}} = image

        points
        |> Evision.boxPoints()
        |> Evision.Mat.to_nx(Nx.BinaryBackend)
        |> Nx.multiply(Nx.tensor([height, width]))
        |> Nx.as_type(:s32)
      end)

    image =
      TextRecognition.CRNN.visualize(
        image,
        texts,
        detections,
        confidences
      )

    %{texts: texts, image: image}
  end
end
