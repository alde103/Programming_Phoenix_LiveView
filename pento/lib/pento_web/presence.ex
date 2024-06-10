defmodule PentoWeb.Presence do
  use Phoenix.Presence,
    otp_app: :pento,
    pubsub_server: Pento.PubSub

  alias PentoWeb.Presence

  @user_activity_topic "user_activity"
  def track_user(pid, product, user_email) do
    Presence.track(
      pid,
      @user_activity_topic,
      product.name,
      %{users: [%{email: user_email}]}
    )
  end

  @survery_users_activity_topic "survery_users_activity"
  def track_user(pid, user) do
    Presence.track(
      pid,
      @survery_users_activity_topic,
      "USERS",
      %{users: [%{email: user.email}]}
    )
  end

  def list_survery_users do
    Presence.list(@survery_users_activity_topic)
    |> Enum.map(&extract_users/1)
    |> Enum.at(0)
    |> get_users_meta()
    |> Enum.count()
  end

  def extract_users({"USERS", %{metas: metas}}) do
    {"USERS", users_from_metas_list(metas)}
  end

  def get_users_meta(nil), do: []
  def get_users_meta(meta_tuple), do: elem(meta_tuple, 1)

  def list_products_and_users do
    Presence.list(@user_activity_topic)
    |> Enum.map(&extract_product_with_users/1)
  end

  def extract_product_with_users({product_name, %{metas: metas}}) do
    {product_name, users_from_metas_list(metas)}
  end

  def users_from_metas_list(metas_list) do
    Enum.map(metas_list, &users_from_meta_map/1)
    |> List.flatten()
    |> Enum.uniq()
  end

  def users_from_meta_map(meta_map) do
    get_in(meta_map, [:users])
  end
end
