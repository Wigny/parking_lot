defmodule ParkingLotWeb.HomeLive.CanvasComponent do
  use Phoenix.Component

  attr(:id, :string)
  attr(:frame, Evision.Mat)

  def preview(%{frame: frame} = assigns) do
    {_dimensions, [height, width]} = Evision.Mat.size(frame)
    base64 = Base.encode64(Evision.imencode(".jpeg", frame))

    assigns =
      assigns
      |> assign(:image, "data:image/jpeg;charset=utf-8;base64,#{base64}")
      |> assign(:width, width)
      |> assign(:height, height)

    ~H"""
    <canvas
      id={@id}
      phx-hook="DrawCanvas"
      data-image={@image}
      width={@width}
      height={@height}
      class="aspect-video max-w-full"
    />
    """
  end
end
