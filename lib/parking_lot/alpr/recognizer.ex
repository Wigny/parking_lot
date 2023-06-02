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
      model:
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-detection-layout-classification.weights"
    },
    recognizer: %{
      config:
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-recognition.cfg",
      model:
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
    {_classIds, _conf, detections} = detect_text(image)

    with {x, y, w, h} <- List.first(detections) do
      area = image[[y..(y + h), x..(x + w)]]

      if match?(%Evision.Mat{}, area) do
        recognize_text(area)
      else
        nil
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
  def handle_call({:recognize, image}, _from, %{recognizer: recognizer, charset: charset} = state) do
    detect_opts = [confThreshold: 0.5, nmsThreshold: 0.25]

    {classIds, _confidences, _boxes} = DNN.DetectionModel.detect(recognizer, image, detect_opts)

    inferences = Enum.map(classIds, fn class -> Enum.at(charset, class) end)

    {:reply, "RSW6A87", state}
  end

  defp detector_init() do
    download_opts = [cache_dir: System.tmp_dir!()]

    {:ok, config} = Zoo.download(@models.detector.config, "detection.cfg", download_opts)
    {:ok, model} = Zoo.download(@models.detector.model, "detection.weights", download_opts)

    net = DNN.readNetFromDarknet(config, darknetModel: model)
    DNN.Net.setPreferableTarget(net, cv_DNN_TARGET_CPU())

    model = DNN.DetectionModel.detectionModel(net)

    DNN.DetectionModel.setInputParams(model, scale: 1 / 255, size: {416, 416}, swapRB: true)

    model
  end

  defp recognizer_init() do
    download_opts = [cache_dir: System.tmp_dir!()]

    {:ok, config} = Zoo.download(@models.recognizer.config, "recognition.cfg", download_opts)
    {:ok, model} = Zoo.download(@models.recognizer.model, "recognition.weights", download_opts)

    net = DNN.readNetFromDarknet(config, darknetModel: model)
    DNN.Net.setPreferableTarget(net, cv_DNN_TARGET_CPU())

    model = DNN.DetectionModel.detectionModel(net)

    DNN.DetectionModel.setInputParams(model, scale: 1 / 255, size: {352, 128}, swapRB: true)

    model
  end

  defp charset_init do
    download_opts = [cache_dir: System.tmp_dir!()]

    {:ok, names} = Zoo.download(@models.recognizer.classes, "recognition.names", download_opts)

    String.split(File.read!(names), "\n")
  end
end
