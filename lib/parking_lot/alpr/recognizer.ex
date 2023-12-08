defmodule ParkingLot.ALPR.Recognizer do
  @moduledoc """
  Based on https://web.inf.ufpr.br/vri/publications/layout-independent-alpr/
  """

  use GenServer
  require Logger

  alias Evision.Mat
  alias ParkingLot.NeuralNetwork

  # Client

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def infer(image) do
    license_plates = detect_license_plate(image)

    with {layout, %Mat{} = area} <- List.first(license_plates) do
      {layout, recognize_license_plate(area)}
    end
  end

  @spec detect_license_plate(image) :: [image] when image: Mat.maybe_mat_in()
  def detect_license_plate(image) do
    detections = GenServer.call(__MODULE__, {:detect_license_plate, image}, :infinity)

    for {class, _confidence, box} <- detections do
      {class, Mat.roi(image, box)}
    end
  end

  @spec recognize_license_plate(image :: Mat.t()) :: [binary]
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

    detection = NeuralNetwork.init(:detection)
    recognition = NeuralNetwork.init(:recognition)

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
