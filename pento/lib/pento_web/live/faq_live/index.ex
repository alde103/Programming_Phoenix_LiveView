defmodule PentoWeb.FAQLive.Index do
  use PentoWeb, :live_view

  alias Pento.Questions
  alias Pento.Questions.FAQ

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :faqs, Questions.list_faqs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit FAQ")
    |> assign(:faq, Questions.get_faq!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New FAQ")
    |> assign(:faq, %FAQ{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing FAQs")
    |> assign(:faq, nil)
  end

  @impl true
  def handle_info({PentoWeb.FAQLive.FormComponent, {:saved, faq}}, socket) do
    {:noreply, stream_insert(socket, :faqs, faq)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    faq = Questions.get_faq!(id)
    {:ok, _} = Questions.delete_faq(faq)

    {:noreply, stream_delete(socket, :faqs, faq)}
  end
end
