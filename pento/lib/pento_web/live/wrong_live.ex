defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    answer = Enum.take_random(1..10, 1) |> Enum.at(0)

    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess: ",
       answer: answer,
       is_winner?: false,
       #  session_id: session["live_socket_id"],
       time: time()
     )}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h3>
      It's <%= @time %>
    </h3>
    <br />
    <%= unless @is_winner? do %>
      <h2>
        <%= for n <- 1..10 do %>
          <.link
            class="bg-blue-500 hover:bg-blue-700
      text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
            phx-click="guess"
            phx-value-number={n}
          >
            <%= n %>
          </.link>
        <% end %>
      </h2>
    <% else %>
      <h2>
        <.link
          class="bg-blue-500 hover:bg-blue-700
      text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="restart"
        >
          Restart
        </.link>
      </h2>
    <% end %>
    <br/>
    <pre>
      <%= @current_user.user_name %>
      <%= @session_id %>
    </pre>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    guess_number = String.to_integer(guess)
    previous_answer = get_in(socket.assigns, [:answer])

    score =
      cond do
        previous_answer == guess_number ->
          socket.assigns.score + 1

        previous_answer != guess_number ->
          socket.assigns.score - 1
      end

    message =
      cond do
        previous_answer != guess_number ->
          "Your guess: #{guess}, Wrong. Previous Answer: #{previous_answer} Guess again."

        score > 0 ->
          "Correct: #{guess}. Previous Answer: #{previous_answer} You win"

        score <= 0 ->
          "Correct: #{guess}. Previous Answer: #{previous_answer} Guess again."
      end

    new_answer = Enum.take_random(1..10, 1) |> Enum.at(0)

    is_winner? = score > 0

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        answer: new_answer,
        is_winner?: is_winner?,
        time: time()
      )
    }
  end

  def handle_event("restart", _event_metadata, socket) do
    new_answer = Enum.take_random(1..10, 1) |> Enum.at(0)

    {
      :noreply,
      assign(
        socket,
        message: "Make a guess: ",
        score: 0,
        answer: new_answer,
        is_winner?: false,
        time: time()
      )
    }
  end

  defp time() do
    DateTime.utc_now() |> to_string
  end
end
