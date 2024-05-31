defmodule PentoWeb.SearchLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.{Search, Catalog}

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="search-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:sku]} type="number" placeholder="SKU"/>

        <:actions>
          <.button phx-disable-with="Searching...">Search</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{search: search} = assigns, socket) do
    changeset = Search.changeset(search, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"search" => search_parameters}, socket) do
    changeset =
      socket.assigns.search
      |> Search.changeset(search_parameters)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"search" => search_parameters}, socket) do
    sku = search_parameters["sku"]
    case Catalog.get_product_by_sku(sku) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply, socket}

      :error ->
        changeset = Search.changeset(%Search{}, %{})
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
