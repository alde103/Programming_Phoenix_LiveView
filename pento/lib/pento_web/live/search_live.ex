defmodule PentoWeb.SearchLive do
  alias Pento.Search
  use PentoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    new_socket =
      socket
      |> assign(:product, [])
      |> assign(:search, %Search{})

    {:ok, new_socket}
  end

  @impl true
  def handle_info({__MODULE__.FormComponent, {:saved, product}}, socket) do
    {:noreply, assign(socket, :product, [product])}
  end
end
