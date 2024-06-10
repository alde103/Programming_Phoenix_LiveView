defmodule PentoWeb.Admin.SurveyUsersActivityLive do
  use PentoWeb, :live_component
  alias PentoWeb.Presence

  def render(assigns) do
    ~H"""
    <section class="row">
      <h2 class="font-light text-2xl"> Number of Users doing the Survery:  <%= inspect(@survey_users_count) %></h2>
    </section>
    <%!-- <h2 class="font-light text-2xl">Survey Results</h2> --%>
    <%!-- <div>

    </div> --%>
    """
  end

  def update(_assigns, socket) do
    {:ok,
     socket
     |> assign_survey_users_activity()}
  end

  def assign_survey_users_activity(socket) do
    survey_users_count =
      Presence.list_survery_users()
    assign(socket, :survey_users_count, Presence.list_survery_users())
  end
end
