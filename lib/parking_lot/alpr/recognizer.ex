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

  @spec infer(image :: Mat.t()) :: {binary, binary, [binary]}
  def infer(image) do
    with {vehicle_type, %Mat{} = vehicle} <- List.first(detect_vehicle(image)),
         {license_plate_layout, %Mat{} = license_plate} <- detect_license_plate(vehicle) do
      license_plate_characters = recognize_license_plate(license_plate)

      {vehicle_type, license_plate_layout, license_plate_characters}
    end
  end

  @spec detect_vehicle(image :: Mat.t()) :: [{binary, Mat.maybe_mat_out()}]
  def detect_vehicle(image) do
    detections = GenServer.call(__MODULE__, {:detect_vehicle, image}, :infinity)

    for {class, _confidence, box} <- detections do
      {class, Mat.roi(image, box)}
    end
  end

  @spec detect_license_plate(image :: Mat.t()) :: {binary, Mat.maybe_mat_out()}
  def detect_license_plate(image) do
    detections = GenServer.call(__MODULE__, {:detect_license_plate, image}, :infinity)

    {class, _confidence, {axis_x, axis_y, width, height}} =
      Enum.max_by(detections, fn {_class, confidence, _box} -> confidence end)

    {class, Mat.roi(image, {axis_x - 5, axis_y - 5, width + 10, height + 10})}
  end

  @spec recognize_license_plate(image :: Mat.t()) :: [binary]
  def recognize_license_plate(image) do
    recognitions = GenServer.call(__MODULE__, {:recognize_license_plate, image}, :infinity)

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
    Logger.info(fn -> "Initializing the neural network models" end)

    vehicle_detection = NeuralNetwork.init(:vehicle_detection)
    license_plate_detection = NeuralNetwork.init(:license_plate_detection)
    license_plate_recognition = NeuralNetwork.init(:license_plate_recognition)

    models = %{
      vehicle_detection: vehicle_detection,
      license_plate_detection: license_plate_detection,
      license_plate_recognition: license_plate_recognition
    }

    {:noreply, models}
  end

  @impl true
  def handle_call({:detect_vehicle, image}, _from, models) do
    inferences = NeuralNetwork.infer(models.vehicle_detection, image, nms_threshold: 0.25)

    {:reply, inferences, models}
  end

  @impl true
  def handle_call({:detect_license_plate, image}, _from, models) do
    inferences = NeuralNetwork.infer(models.license_plate_detection, image, nms_threshold: 0.5)

    {:reply, inferences, models}
  end

  @impl true
  def handle_call({:recognize_license_plate, image}, _from, models) do
    inferences = NeuralNetwork.infer(models.license_plate_recognition, image, nms_threshold: 0.25)

    {:reply, inferences, models}
  end
end
