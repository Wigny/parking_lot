defmodule ParkingLot.NeuralNetwork do
  @moduledoc false

  alias Evision.Constant
  alias ParkingLot.ReqCacheFile
  alias Evision.DNN
  alias Evision.DNN.{DetectionModel, Net}

  defstruct ~w[model classes]a

  @base_url "http://www.inf.ufpr.br/vri/databases/layout-independent-alpr/data"

  @models %{
    detection: %{
      filenames: %{
        config: "lp-detection-layout-classification.cfg",
        weights: "lp-detection-layout-classification.weights",
        classes: "lp-detection-layout-classification.names"
      },
      size: {416, 416}
    },
    recognition: %{
      filenames: %{
        config: "lp-recognition.cfg",
        weights: "lp-recognition.weights",
        classes: "lp-recognition.names"
      },
      size: {352, 128}
    }
  }

  @target_device Constant.cv_DNN_TARGET_CPU()
  @computation_backend Constant.cv_DNN_BACKEND_DEFAULT()

  def init(model) do
    %{filenames: filenames, size: size} = @models[model]

    config_file = download(filenames[:config])
    weights_file = download(filenames[:weights])
    classes_file = download(filenames[:classes])

    model =
      config_file
      |> DNN.readNetFromDarknetBuffer(bufferModel: weights_file)
      |> Net.setPreferableTarget(@target_device)
      |> Net.setPreferableBackend(@computation_backend)
      |> DetectionModel.detectionModel()
      |> DetectionModel.setInputParams(scale: 1 / 255, size: size, swapRB: true)

    classes = String.split(classes_file, "\n")

    struct!(__MODULE__, model: model, classes: classes)
  end

  def infer(%__MODULE__{model: model, classes: classes}, image, opts) do
    detect_opts = [confThreshold: opts[:threshold], nmsThreshold: opts[:nms_threshold]]
    {class_ids, confidences, boxes} = DetectionModel.detect(model, image, detect_opts)

    [class_ids, confidences, boxes]
    |> Enum.zip()
    |> Enum.map(fn {class_id, confidence, box} ->
      class = Enum.at(classes, class_id)
      {class, confidence, box}
    end)
  end

  defp download(file) do
    [base_url: @base_url]
    |> Req.new()
    |> ReqCacheFile.attach(cache_dir: Application.get_env(:parking_lot, :cache_dir))
    |> Req.get!(url: file)
    |> Map.fetch!(:body)
  end
end
