defmodule Pento.Questions.FAQ do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faqs" do
    field :question, :string
    has_many(:answers, Pento.Questions.Answer)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(faq, attrs) do
    faq
    |> cast(attrs, [:question])
    |> validate_required([:question])
  end
end
