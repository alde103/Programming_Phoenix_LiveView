defmodule PentoWeb.FAQLive.Show do
  use PentoWeb, :live_view

  alias Pento.Questions
  alias Pento.Questions.Answer

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, stream(socket, :answers, Questions.get_all_answers_by_faq_id(id))}
  end

  @impl true
  def handle_params(%{"id" => faq_id, "answer_id" => answer_id}, _, socket) do
    faq = Questions.get_faq!(faq_id)

    new_socket =
      socket
      |> assign(:faq, faq)
      |> assign(:page_title, page_title(socket.assigns.live_action, faq))
      |> assign(:answer, Questions.get_answer!(answer_id))

    {:noreply, new_socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    faq = Questions.get_faq!(id)

    new_socket =
      socket
      |> assign(:faq, faq)
      |> assign(:page_title, page_title(socket.assigns.live_action, faq))
      |> assign(:answer, %Answer{})

    {:noreply, new_socket}
  end

  @impl true
  def handle_info({PentoWeb.FAQLive.AnswerFormComponent, {:saved, answer}}, socket) do
    {:noreply, stream_insert(socket, :answers, answer)}
  end

  @impl true
  def handle_info({PentoWeb.FAQLive.FormComponent, {:saved, faq}}, socket) do
    {:noreply, assign(socket, :faq, faq)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    answer = Questions.get_answer!(id)
    {:ok, _} = Questions.delete_answer(answer)

    {:noreply, stream_delete(socket, :answers, answer)}
  end

  @impl true
  def handle_event("vote", %{"value" => answer_id}, socket) do
    answer = Questions.get_answer!(answer_id)
    current_votes = answer.votes
    {:ok, updated_answer} = Questions.update_answer(answer, %{"votes" => current_votes + 1})

    {:noreply, stream_insert(socket, :answers, updated_answer)}
  end

  defp page_title(:show, _faq), do: "Show Faq"
  defp page_title(:edit, _faq), do: "Edit Faq"
  defp page_title(:new_answer, faq), do: "Question: #{faq.question}"
  defp page_title(:edit_answer, faq), do: "Question: #{faq.question}"
end
