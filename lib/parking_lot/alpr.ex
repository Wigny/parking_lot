defmodule ParkingLot.ALPR do
  alias GoogleApi.Vision.V1.{Connection, Api, Model}

  @credentials "GOOGLE_APPLICATION_CREDENTIALS"
               |> System.fetch_env!()
               |> Jason.decode!()

  @plate_regex ~r/(?<legacy>[A-Z]{3}-?[0-9]{4})|(?<mercosul>[A-Z]{3}[0-9][A-Z][0-9]{2})/

  def client do
    with {:ok, token} <- Goth.Token.fetch(source: {:service_account, @credentials}) do
      Connection.new(token.token)
    end
  end

  def recognize(image) do
    client = client()

    body = %Model.BatchAnnotateImagesRequest{
      requests: [
        %Model.AnnotateImageRequest{
          image: %Model.Image{content: image},
          features: %Model.Feature{type: "TEXT_DETECTION", model: "builtin/latest"}
        }
      ]
    }

    with {:ok, %{responses: [response]}} <- Api.Images.vision_images_annotate(client, body: body) do
      capture(response)
    end
  end

  defp capture(%{fullTextAnnotation: %{text: text}}) do
    if plates = Regex.run(@plate_regex, text) do
      {:ok, List.first(plates)}
    else
      {:ok, nil}
    end
  end

  defp capture(_response) do
    {:error, nil}
  end
end
