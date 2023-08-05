defmodule ParkingLot.ALPR.Recognizer do
  @moduledoc """
  Based on https://web.inf.ufpr.br/vri/publications/layout-independent-alpr/
  """

  use GenServer
  import Evision.Constant
  require Logger

  defmodule NeuralNetwork do
    @moduledoc false

    alias Evision.DNN

    defstruct ~w[model classes]a

    @models %{
      detection: %{
        config:
          "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-detection-layout-classification.cfg",
        weights:
          "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-detection-layout-classification.weights",
        classes:
          "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-detection-layout-classification.names"
      },
      recognition: %{
        config:
          "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-recognition.cfg",
        weights:
          "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-recognition.weights",
        classes:
          "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-recognition.names"
      }
    }

    def init(model, opts) do
      %{config: config_url, weights: weights_url, classes: classes_url} = @models[model]

      {:ok, config_path} = Evision.Zoo.download(config_url, Path.basename(config_url))
      {:ok, weights_path} = Evision.Zoo.download(weights_url, Path.basename(weights_url))
      {:ok, classes_path} = Evision.Zoo.download(classes_url, Path.basename(classes_url))

      classes = String.split(File.read!(classes_path), "\n")

      network = DNN.readNetFromDarknet(config_path, darknetModel: weights_path)
      DNN.Net.setPreferableTarget(network, cv_DNN_TARGET_CPU())

      model =
        network
        |> DNN.DetectionModel.detectionModel()
        |> DNN.DetectionModel.setInputParams(
          scale: 1 / 255,
          size: {opts[:width], opts[:height]},
          swapRB: true
        )

      struct!(__MODULE__, model: model, classes: classes)
    end

    def infer(%__MODULE__{model: model, classes: classes}, image, opts) do
      detect_opts = [
        confThreshold: opts[:threshold],
        nmsThreshold: opts[:nms_threshold]
      ]

      {class_ids, confidences, boxes} = DNN.DetectionModel.detect(model, image, detect_opts)

      [class_ids, confidences, boxes]
      |> Enum.zip()
      |> Enum.map(fn {class_id, confidence, box} ->
        class = Enum.at(classes, class_id)
        {class, confidence, box}
      end)
    end
  end

  # Client

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def infer(image) do
    license_plates = detect_license_plate(image)

    with %Evision.Mat{} = area <- List.first(license_plates) do
      recognize_license_plate(area)
    end
  end

  @spec detect_license_plate(image) :: [image] when image: Evision.Mat.maybe_mat_in()
  def detect_license_plate(image) do
    detections = GenServer.call(__MODULE__, {:detect_license_plate, image}, :infinity)

    for {_class, _confidence, box} <- detections do
      Evision.Mat.roi(image, box)
    end
  end

  @spec recognize_license_plate(image :: Evision.Mat.t()) :: [binary]
  def recognize_license_plate(image) do
    recognitions = GenServer.call(__MODULE__, {:recognize_license_plate, image})

    recognitions
    |> Enum.sort_by(fn {_class, _confidence, {axis_x, axis_y, _width, _height}} ->
      {axis_x, axis_y}
    end)
    |> Enum.map(fn {class, _confidence, _box} ->
      class
    end)
  end

  # Server

  @impl true
  def init(_args) do
    {:ok, nil, {:continue, :init}}
  end

  @impl true
  def handle_continue(:init, nil) do
    Logger.info("Initializing the neural network models")

    detection = NeuralNetwork.init(:detection, width: 416, height: 416)
    recognition = NeuralNetwork.init(:recognition, width: 352, height: 128)

    {:noreply, %{detection: detection, recognition: recognition}}
  end

  @impl true
  def handle_call({:detect_license_plate, image}, _from, %{detection: model} = models) do
    inferences = NeuralNetwork.infer(model, image, threshold: 0.01)

    {:reply, inferences, models}
  end

  @impl true
  def handle_call({:recognize_license_plate, image}, _from, %{recognition: model} = models) do
    inferences = NeuralNetwork.infer(model, image, threshold: 0.5, nms_threshold: 0.25)

    {:reply, inferences, models}
  end
end
