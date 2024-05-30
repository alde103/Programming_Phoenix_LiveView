defmodule PentoWeb.FAQLive.AnswerFormComponent do
  use PentoWeb, :live_component

  alias Pento.Questions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Add a response for the following question.
        <:subtitle><%= @title %></:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="answer-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:answer]} type="text" label="Answer" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Answer</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{answer: answer} = assigns, socket) do
    changeset = Questions.change_answer(answer)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"answer" => answer_params}, socket) do
    changeset =
      socket.assigns.answer
      |> Questions.change_answer(answer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"answer" => answer_params}, socket) do
    save_answer(socket, socket.assigns, answer_params)
  end

  defp save_answer(socket, %{action: :edit_answer} = assigns, answer_params) do
    case Questions.update_answer(assigns.answer, answer_params) do
      {:ok, answer} ->
        notify_parent({:saved, answer})

        {:noreply,
         socket
         |> put_flash(:info, "Faq updated successfully")
         |> push_patch(to: assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_answer(socket, %{action: :new_answer} = assigns, answer_params) do
    faq_id = get_in(assigns, [:faq_id])
    user_id = get_in(assigns, [:user_id])

    complete_answer_params =
      answer_params
      |> Map.put("faq_id", faq_id)
      |> Map.put("user_id", user_id)
      |> Map.put("votes", 0)

    case Questions.create_answer(complete_answer_params) do
      {:ok, answer} ->
        notify_parent({:saved, answer})

        {:noreply,
         socket
         |> put_flash(:info, "Answer created successfully")
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
