defmodule Pento.QuestionsTest do
  use Pento.DataCase

  alias Pento.Questions

  describe "faqs" do
    alias Pento.Questions.FAQ

    import Pento.QuestionsFixtures

    @invalid_attrs %{question: nil}

    test "list_faqs/0 returns all faqs" do
      faq = faq_fixture()
      assert Questions.list_faqs() == [faq]
    end

    test "get_faq!/1 returns the faq with given id" do
      faq = faq_fixture()
      assert Questions.get_faq!(faq.id) == faq
    end

    test "create_faq/1 with valid data creates a faq" do
      valid_attrs = %{question: "some question"}

      assert {:ok, %FAQ{} = faq} = Questions.create_faq(valid_attrs)
      assert faq.question == "some question"
    end

    test "create_faq/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_faq(@invalid_attrs)
    end

    test "update_faq/2 with valid data updates the faq" do
      faq = faq_fixture()
      update_attrs = %{question: "some updated question"}

      assert {:ok, %FAQ{} = faq} = Questions.update_faq(faq, update_attrs)
      assert faq.question == "some updated question"
    end

    test "update_faq/2 with invalid data returns error changeset" do
      faq = faq_fixture()
      assert {:error, %Ecto.Changeset{}} = Questions.update_faq(faq, @invalid_attrs)
      assert faq == Questions.get_faq!(faq.id)
    end

    test "delete_faq/1 deletes the faq" do
      faq = faq_fixture()
      assert {:ok, %FAQ{}} = Questions.delete_faq(faq)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_faq!(faq.id) end
    end

    test "change_faq/1 returns a faq changeset" do
      faq = faq_fixture()
      assert %Ecto.Changeset{} = Questions.change_faq(faq)
    end
  end

  describe "answer" do
    alias Pento.Questions.Answer

    import Pento.QuestionsFixtures

    @invalid_attrs %{answer: nil, votes: nil}

    test "list_answer/0 returns all answer" do
      answer = answer_fixture()
      assert Questions.list_answer() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Questions.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      valid_attrs = %{answer: "some answer", votes: 42}

      assert {:ok, %Answer{} = answer} = Questions.create_answer(valid_attrs)
      assert answer.answer == "some answer"
      assert answer.votes == 42
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      update_attrs = %{answer: "some updated answer", votes: 43}

      assert {:ok, %Answer{} = answer} = Questions.update_answer(answer, update_attrs)
      assert answer.answer == "some updated answer"
      assert answer.votes == 43
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Questions.update_answer(answer, @invalid_attrs)
      assert answer == Questions.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Questions.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Questions.change_answer(answer)
    end
  end
end
