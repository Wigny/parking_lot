defmodule ParkingLot.ALPR.Recognizer do
  @moduledoc """
  Based on https://web.inf.ufpr.br/vri/publications/layout-independent-alpr/
  """

  use GenServer
  import Evision.Constant
  alias Evision.{DNN, Zoo}

  # Client

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def infer(image) do
    {_classIds, _conf, detections} = detect_text(image)

    with {x, y, w, h} <- List.first(detections) do
      area = image[[y..(y + h), x..(x + w)]]

      if match?(%Evision.Mat{}, area) do
        recognize_text(area)
      end
    end
  end

  def detect_text(image) do
    GenServer.call(__MODULE__, {:detect, image}, :infinity)
  end

  def recognize_text(image) do
    GenServer.call(__MODULE__, {:recognize, image})
  end

  # Server

  @impl true
  def init(_state) do
    {:ok, nil, {:continue, :init}}
  end

  @impl true
  def handle_continue(:init, nil) do
    detector = detector_init()
    recognizer = recognizer_init()
    charset = charset_init()

    {:noreply, %{detector: detector, recognizer: recognizer, charset: charset}}
  end

  @impl true
  def handle_call({:detect, image}, _from, %{detector: detector} = state) do
    inference = DNN.DetectionModel.detect(detector, image, confThreshold: 0.01)
    {:reply, inference, state}
  end

  @impl true
  def handle_call({:recognize, image}, _from, state) do
    %{recognizer: recognizer, charset: charset} = state

    blob = DNN.blobFromImage(image, scalefactor: 1 / 255, size: {352, 128}, swapRB: true)

    recognizer = DNN.Net.setInput(recognizer, blob)

    output_layers_names = DNN.Net.getUnconnectedOutLayersNames(recognizer)
    [outputBlob] = DNN.Net.forward(recognizer, outBlobNames: output_layers_names)

    output = Evision.Mat.to_nx(outputBlob, Nx.BinaryBackend)

    inference =
      0..(Nx.axis_size(output, 0) - 1)
      |> Enum.reduce([], fn i, acc ->
        scores = output[[i, 5..-1//1]]

        class_id = Nx.to_number(Nx.argmax(scores))
        confidence = Nx.to_number(scores[class_id])

        if confidence > 0.5 do
          char = Enum.at(charset, class_id)
          Enum.concat(acc, [char])
        else
          acc
        end
      end)
      |> Enum.join()

    {:reply, inference, state}
  end

  defp detector_init() do
    {:ok, config} =
      Zoo.download(
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-detection-layout-classification.cfg",
        "detection.cfg"
      )

    {:ok, model} =
      Zoo.download(
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-detection-layout-classification.weights",
        "detection.weights"
      )

    net = DNN.readNetFromDarknet(config, darknetModel: model)
    DNN.Net.setPreferableTarget(net, cv_DNN_TARGET_CPU())

    model = DNN.DetectionModel.detectionModel(net)

    DNN.DetectionModel.setInputParams(model, scale: 1 / 255, size: {416, 416}, swapRB: true)

    model
  end

  defp recognizer_init() do
    {:ok, config} =
      Evision.Zoo.download(
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-recognition.cfg",
        "recognition.cfg"
      )

    {:ok, model} =
      Evision.Zoo.download(
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-recognition.weights",
        "recognition.weights"
      )

    net = DNN.readNetFromDarknet(config, darknetModel: model)
    DNN.Net.setPreferableTarget(net, cv_DNN_TARGET_CPU())
    net
  end

  defp charset_init() do
    {:ok, names} =
      Evision.Zoo.download(
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-recognition.names",
        "recognition.names"
      )

    String.split(File.read!(names), "\n")
  end
end
