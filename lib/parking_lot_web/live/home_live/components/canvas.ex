defmodule ParkingLotWeb.HomeLive.CanvasComponent do
  use Phoenix.Component

  import ParkingLotWeb.CoreComponents

  attr :id, :string
  attr :frame, Evision.Mat

  def canvas(%{frame: frame} = assigns) when is_struct(frame, Evision.Mat) do
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
      class="aspect-video object-cover w-full h-auto"
    />
    """
  end

  def canvas(assigns) do
    ~H"""
    <div class="bg-gray-300 aspect-video max-w-full flex items-center justify-center">
      <.icon name="hero-video-camera-slash" class="text-gray-500 h-[75px] w-[75px]" />
    </div>
    """
  end
end
