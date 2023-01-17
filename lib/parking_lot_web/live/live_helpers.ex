defmodule ParkingLotWeb.LiveHelpers do
  @moduledoc false

  import Phoenix.Component

  alias Phoenix.LiveView.JS

  def datetime(assigns) do
    assigns = assign_new(assigns, :id, &Ecto.UUID.generate/0)

    ~H"""
    <time phx-hook="LocalDateTime" id={@id}><%= @value %></time>
    """
  end

  def mask(%{value: value, pattern: pattern} = assigns) do
    assigns = assign(assigns, :text, mask_text(value, pattern))

    ~H"""
    <span><%= @text %></span>
    """
  end

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.driver_index_path(@socket, :index)}>
        <.live_component
          module={ParkingLotWeb.DriverLive.FormComponent}
          id={@driver.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.driver_index_path(@socket, :index)}
          driver: @driver
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <.link id="close" patch={@return_to} class="phx-modal-close" phx-click={hide_modal()}>
            ✖
          </.link>
        <% else %>
          <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>
            ✖
          </a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  defp mask_text(value, pattern, acc \\ "")

  defp mask_text(<<>>, _pattern, acc) do
    acc
  end

  defp mask_text(<<v, value::binary>>, <<p::binary-size(1), pattern::binary>>, acc)
       when p in ~w[0 a] do
    mask_text(value, pattern, <<acc::binary, v>>)
  end

  defp mask_text(value, <<p, pattern::binary>>, acc) do
    mask_text(value, pattern, <<acc::binary, p>>)
  end
end
