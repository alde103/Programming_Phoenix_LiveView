defmodule Pento.Questions.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answer" do
    field :answer, :string
    field :votes, :integer
    belongs_to(:faq, Pento.Questions.FAQ)
    belongs_to(:user, Pento.Accounts.User)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:answer, :votes, :user_id, :faq_id])
    |> validate_required([:answer, :votes, :faq_id])
    |> assoc_constraint(:faq)
    |> assoc_constraint(:user)
  end
end
