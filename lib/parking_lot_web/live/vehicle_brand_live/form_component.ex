defmodule ParkingLotWeb.VehicleBrandLive.FormComponent do
  use ParkingLotWeb, :live_component

  alias ParkingLot.Vehicles

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="brand-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label={gettext("Name")} />
        <:actions>
          <.button phx-disable-with={gettext("Saving...")}><%= gettext("Save brand") %></.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{brand: brand} = assigns, socket) do
    changeset = Vehicles.change_brand(brand)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"brand" => brand_params}, socket) do
    changeset =
      socket.assigns.brand
      |> Vehicles.change_brand(brand_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"brand" => brand_params}, socket) do
    save_brand(socket, socket.assigns.action, brand_params)
  end

  defp save_brand(socket, :edit, brand_params) do
    case Vehicles.update_brand(socket.assigns.brand, brand_params) do
      {:ok, brand} ->
        notify_parent({:saved, brand})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Brand updated successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_brand(socket, :new, brand_params) do
    case Vehicles.create_brand(brand_params) do
      {:ok, brand} ->
        notify_parent({:saved, brand})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Brand created successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
