defmodule PentoWeb.Admin.SurveyUsersActivityLive do
  use PentoWeb, :live_component
  alias PentoWeb.Presence

  def render(assigns) do
    ~H"""
    <section class="row">
      <h2 class="font-light text-2xl"> Number of Users doing the Survery:  <%= inspect(@survey_users_count) %></h2>
    </section>
    """
  end

  def update(_assigns, socket) do
    {:ok,
     socket
     |> assign_survey_users_activity()}
  end

  def assign_survey_users_activity(socket) do
    assign(socket, :survey_users_count, Presence.list_survery_users())
  end
end
