defmodule Pento.QuestionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Questions` context.
  """

  @doc """
  Generate a faq.
  """
  def faq_fixture(attrs \\ %{}) do
    {:ok, faq} =
      attrs
      |> Enum.into(%{
        question: "some question"
      })
      |> Pento.Questions.create_faq()

    faq
  end

  @doc """
  Generate a answer.
  """
  def answer_fixture(attrs \\ %{}) do
    {:ok, answer} =
      attrs
      |> Enum.into(%{
        answer: "some answer",
        votes: 42
      })
      |> Pento.Questions.create_answer()

    answer
  end
end
