defmodule ParkingLot.ALPR.Recognizer do
  @moduledoc """
  Based on https://github.com/opencv/opencv_zoo/tree/master/models/text_recognition_crnn by
  https://github.com/cocoa-xu/evision/pull/143
  """

  use GenServer
  import Evision.Constant
  alias Evision.DNN

  # Client

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def infer(image) do
    # {_classIds, _conf, detections} = detect_text(image)

    # Enum.map(detections, fn {x, y, w, h} ->
    #   area = image[[y..(y + h), x..(x + w)]]

    #   if match?(%Evision.Mat{}, area) do
    #     Evision.imwrite("area.jpg", area)
    #     recognize_text(area)
    #   end
    # end)

    recognize_text(Evision.imread("lib/parking_lot/alpr/plate.png"))
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
    opts = [backend: cv_DNN_BACKEND_CUDA(), target: cv_DNN_TARGET_CUDA()]

    detector = detector_init(opts)
    recognizer = recognizer_init(opts)

    {:noreply, %{detector: detector, recognizer: recognizer}}
  end

  @impl true
  def handle_call({:detect, image}, _from, %{detector: detector} = state) do
    inference = DNN.DetectionModel.detect(detector, image, confThreshold: 0.2, nmsThreshold: 0.4)
    {:reply, inference, state}
  end

  @impl true
  def handle_call({:recognize, image}, _from, %{recognizer: recognizer} = state) do
    blob =
      DNN.blobFromImage(image, scalefactor: 1 / 255, size: {352, 128}, swapRB: true, crop: false)

    out_names = DNN.Net.getUnconnectedOutLayersNames(recognizer)

    recognizer = DNN.Net.setInput(recognizer, blob)

    [outputBlob] = DNN.Net.forward(recognizer, outBlobNames: out_names)

    charset = Enum.map(Enum.concat(?0..?9, ?A..?Z), &<<&1::utf8>>)

    output = Evision.Mat.to_nx(outputBlob, Nx.BinaryBackend)

    for i <- 0..(Nx.axis_size(output, 0) - 1), reduce: [] do
      acc ->
        scores = output[[i, 5..-1//1]]

        class_id = Nx.to_number(Nx.argmax(scores))
        confidence = Nx.to_number(scores[class_id])

        if confidence != 0, do: IO.inspect({class_id, confidence}, limit: :infinity)

        if confidence > 0.5 do
          char = Enum.at(charset, class_id)
          Enum.concat(acc, [char])
        else
          acc
        end
    end
    |> IO.inspect()

    {:reply, nil, state}
  end

  defp detector_init(opts) do
    {:ok, config} =
      Evision.Zoo.download(
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-detection-layout-classification.cfg",
        "lp-detection-layout-classification.cfg"
      )

    {:ok, model} =
      Evision.Zoo.download(
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-detection-layout-classification.weights",
        "lp-detection-layout-classification.weights"
      )

    net = DNN.readNetFromDarknet(config, darknetModel: model)
    DNN.Net.setPreferableBackend(net, opts[:backend])
    DNN.Net.setPreferableTarget(net, opts[:target])

    model = DNN.DetectionModel.detectionModel(net)

    DNN.DetectionModel.setInputParams(model, size: {416, 416}, scale: 1 / 255, swapRB: true)

    model
  end

  defp recognizer_init(opts) do
    {:ok, config} =
      Evision.Zoo.download(
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-recognition.cfg",
        "lp-recognition.cfg"
      )

    {:ok, model} =
      Evision.Zoo.download(
        "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data/lp-recognition.weights",
        "lp-recognition.weights"
      )

    net = DNN.readNetFromDarknet(config, darknetModel: model)
    DNN.Net.setPreferableBackend(net, opts[:backend])
    DNN.Net.setPreferableTarget(net, opts[:target])

    net
  end
end
