defmodule PentoWeb.Admin.DashboardLive do
  use PentoWeb, :live_view
  alias PentoWeb.Endpoint
  alias PentoWeb.Admin.{SurveyResultsLive, UserActivityLive, SurveyUsersActivityLive}
  @survey_results_topic "survey_results"
  @user_activity_topic "user_activity"
  @survery_users_activity_topic "survery_users_activity"
  require Logger

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
      Endpoint.subscribe(@user_activity_topic)
      Endpoint.subscribe(@survery_users_activity_topic)
    end

    {:ok,
     socket
     |> assign(:survey_results_component_id, "survey-results")
     |> assign(:user_activity_component_id, "user-activity")
     |> assign(:survey_users_activity_component_id, "survey-users-activity")}
  end

  def handle_info(%{event: "rating_created"}, socket) do
    send_update(
      SurveyResultsLive,
      id: socket.assigns.survey_results_component_id
    )

    {:noreply, socket}
  end

  def handle_info(%{topic: @user_activity_topic, event: "presence_diff"} = event, socket) do
    Logger.info("Handling Presence: for #{inspect(event)}")

    send_update(
      UserActivityLive,
      id: socket.assigns.user_activity_component_id
    )

    {:noreply, socket}
  end

  def handle_info(%{topic: @survery_users_activity_topic, event: "presence_diff"} = event, socket) do
    Logger.info("Handling Presence: for #{inspect(event)}")

    send_update(
      SurveyUsersActivityLive,
      id: socket.assigns.survey_users_activity_component_id
    )

    {:noreply, socket}
  end
end
