defmodule ParkingLot.ALPR.Recognizer do
  @moduledoc """
  Based on https://web.inf.ufpr.br/vri/publications/layout-independent-alpr/
  """

  use GenServer
  import Evision.Constant
  alias Evision.DNN
  require Logger

  @models %{
    detector: %{
      config:
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-detection-layout-classification.cfg",
      weights:
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-detection-layout-classification.weights",
      classes:
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-detection-layout-classification.names"
    },
    recognizer: %{
      config:
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-recognition.cfg",
      weights:
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-recognition.weights",
      classes:
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-recognition.names"
    }
  }

  # Client

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def infer(image) do
    detections = detect_license_plate(image)

    with {_class, _confidence, {x, y, width, height}} <- List.first(detections) do
      recognitions = recognize_text(image[[y..(y + height), x..(x + width)]])

      recognitions
      |> Enum.sort_by(fn {_class, _confidence, {x, y, _width, _height}} -> {x, y} end)
      |> Enum.map(fn {class, _confidence, _box} -> class end)
    end
  end

  def detect_license_plate(image) do
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
    detector = init_model(:detector, scale: 1 / 255, size: {416, 416}, swapRB: true)
    recognizer = init_model(:recognizer, scale: 1 / 255, size: {352, 128}, swapRB: true)

    {:noreply, %{detector: detector, recognizer: recognizer}}
  end

  @impl true
  def handle_call({:detect, image}, _from, %{detector: detector} = state) do
    inferences = infer(detector, image, confThreshold: 0.01)

    {:reply, inferences, state}
  end

  @impl true
  def handle_call({:recognize, image}, _from, %{recognizer: recognizer} = state) do
    inferences = infer(recognizer, image, confThreshold: 0.5, nmsThreshold: 0.25)

    {:reply, inferences, state}
  end

  defp init_model(model, input_params) do
    %{config: config_url, weights: weights_url, classes: classes_url} = @models[model]

    Logger.info("Initializing the `license plate #{model}` neural network")

    {:ok, config_path} = Evision.Zoo.download(config_url, Path.basename(config_url))
    {:ok, weights_path} = Evision.Zoo.download(weights_url, Path.basename(weights_url))
    {:ok, classes_path} = Evision.Zoo.download(classes_url, Path.basename(classes_url))

    classes = String.split(File.read!(classes_path), "\n")

    network = DNN.readNetFromDarknet(config_path, darknetModel: weights_path)
    DNN.Net.setPreferableTarget(network, cv_DNN_TARGET_CPU())

    model = DNN.DetectionModel.detectionModel(network)
    DNN.DetectionModel.setInputParams(model, input_params)

    {model, classes}
  end

  defp infer({model, classes}, image, opts) do
    detection = DNN.DetectionModel.detect(model, image, opts)

    detection
    |> Tuple.to_list()
    |> Enum.zip()
    |> Enum.map(fn {classId, confidence, box} ->
      class = Enum.at(classes, classId)
      {class, confidence, box}
    end)
  end
end
