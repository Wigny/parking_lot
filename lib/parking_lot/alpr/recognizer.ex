defmodule ParkingLot.ALPR.Recognizer do
  @moduledoc """
  Based on https://web.inf.ufpr.br/vri/publications/layout-independent-alpr/
  """

  use GenServer
  import Evision.Constant
  alias Evision.{DNN, Zoo}

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
    with {x, y, w, h} <- detect_license_plate(image) do
      area = image[[y..(y + h), x..(x + w)]]

      recognize_text(area)
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
    opts = [target_device: cv_DNN_TARGET_CPU(), cache_dir: System.tmp_dir!()]

    detector = detector_init(@models.detector, opts)
    recognizer = recognizer_init(@models.recognizer, opts)

    {:noreply, %{detector: detector, recognizer: recognizer}}
  end

  @impl true
  def handle_call({:detect, image}, _from, %{detector: detector} = state) do
    inferences = infer(detector, image, confThreshold: 0.01)

    area = with {_class, _confidence, box} <- List.first(inferences), do: box
    {:reply, area, state}
  end

  @impl true
  def handle_call({:recognize, image}, _from, %{recognizer: recognizer} = state) do
    opts = [confThreshold: 0.5, nmsThreshold: 0.25]
    inferences = infer(recognizer, image, opts)

    characters = Enum.map(inferences, fn {class, _confidence, _box} -> class end)
    {:reply, characters, state}
  end

  defp detector_init(model, opts) do
    download_opts = [cache_dir: opts[:cache_dir]]

    {:ok, config} = Zoo.download(model.config, "detection.cfg", download_opts)
    {:ok, weights} = Zoo.download(model.weights, "detection.weights", download_opts)
    {:ok, classes} = Zoo.download(model.classes, "detection.names", download_opts)

    net = DNN.readNetFromDarknet(config, darknetModel: weights)
    DNN.Net.setPreferableTarget(net, opts[:target_device])

    model = DNN.DetectionModel.detectionModel(net)

    DNN.DetectionModel.setInputParams(model, scale: 1 / 255, size: {416, 416}, swapRB: true)

    classes = String.split(File.read!(classes), "\n")

    {model, classes}
  end

  defp recognizer_init(model, opts) do
    download_opts = [cache_dir: opts[:cache_dir]]

    {:ok, config} = Zoo.download(model.config, "recognition.cfg", download_opts)
    {:ok, weights} = Zoo.download(model.weights, "recognition.weights", download_opts)
    {:ok, classes} = Zoo.download(model.classes, "recognition.names", download_opts)

    net = DNN.readNetFromDarknet(config, darknetModel: weights)
    DNN.Net.setPreferableTarget(net, opts[:target_device])

    model = DNN.DetectionModel.detectionModel(net)

    DNN.DetectionModel.setInputParams(model, scale: 1 / 255, size: {352, 128}, swapRB: true)

    classes = String.split(File.read!(classes), "\n")

    {model, classes}
  end

  defp infer({net, classes}, image, opts) do
    detection = DNN.DetectionModel.detect(net, image, opts)

    detection
    |> Tuple.to_list()
    |> Enum.zip()
    |> Enum.map(fn {classId, confidence, box} ->
      class = Enum.at(classes, classId)
      {class, confidence, box}
    end)
  end
end
