defmodule Pento.Questions do
  @moduledoc """
  The Questions context.
  """

  import Ecto.Query, warn: false
  alias Pento.Repo
  alias Pento.Questions.Answer
  alias Pento.Questions.FAQ

  @doc """
  Returns the list of faqs.

  ## Examples

      iex> list_faqs()
      [%FAQ{}, ...]

  """
  def list_faqs do
    Repo.all(FAQ)
  end

  @doc """
  Gets a single faq.

  Raises `Ecto.NoResultsError` if the Faq does not exist.

  ## Examples

      iex> get_faq!(123)
      %FAQ{}

      iex> get_faq!(456)
      ** (Ecto.NoResultsError)

  """
  def get_faq!(id), do: Repo.get!(FAQ, id)

  @doc """
  Gets a single faq with answers.

  Raises `Ecto.NoResultsError` if the Faq does not exist.

  ## Examples

      iex> get_faq!(123)
      %FAQ{}

      iex> get_faq!(456)
      ** (Ecto.NoResultsError)

  """
  def get_faq_with_answer!(id) do
    FAQ
    |> Repo.get!(id)
    |> Repo.preload(answers: from(a in Answer, order_by: [desc: a.inserted_at]))
    |> Repo.preload(answers: [:user])
  end

  @doc """
  Creates a faq.

  ## Examples

      iex> create_faq(%{field: value})
      {:ok, %FAQ{}}

      iex> create_faq(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_faq(attrs \\ %{}) do
    %FAQ{}
    |> FAQ.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a faq.

  ## Examples

      iex> update_faq(faq, %{field: new_value})
      {:ok, %FAQ{}}

      iex> update_faq(faq, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_faq(%FAQ{} = faq, attrs) do
    faq
    |> FAQ.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a faq.

  ## Examples

      iex> delete_faq(faq)
      {:ok, %FAQ{}}

      iex> delete_faq(faq)
      {:error, %Ecto.Changeset{}}

  """
  def delete_faq(%FAQ{} = faq) do
    Repo.delete(faq)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking faq changes.

  ## Examples

      iex> change_faq(faq)
      %Ecto.Changeset{data: %FAQ{}}

  """
  def change_faq(%FAQ{} = faq, attrs \\ %{}) do
    FAQ.changeset(faq, attrs)
  end

  @doc """
  Returns the list of answer.

  ## Examples

      iex> list_answer()
      [%Answer{}, ...]

  """
  def list_answer do
    Repo.all(Answer)
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer!(123)
      %Answer{}

      iex> get_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer!(id), do: Repo.get!(Answer, id)

  @doc """
  Gets answers based on the FAQ.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer!(123)
      [%Answer{}]

      iex> get_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_all_answers_by_faq_id(faq_id) do
    from(a in Answer, where: a.faq_id == ^faq_id, order_by: [desc: a.votes])
    |> Repo.all()
  end

  @doc """
  Creates a answer.

  ## Examples

      iex> create_answer(%{field: value})
      {:ok, %Answer{}}

      iex> create_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer(attrs \\ %{}) do
    %Answer{}
    |> Answer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer.

  ## Examples

      iex> update_answer(answer, %{field: new_value})
      {:ok, %Answer{}}

      iex> update_answer(answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a answer.

  ## Examples

      iex> delete_answer(answer)
      {:ok, %Answer{}}

      iex> delete_answer(answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer changes.

  ## Examples

      iex> change_answer(answer)
      %Ecto.Changeset{data: %Answer{}}

  """
  def change_answer(%Answer{} = answer, attrs \\ %{}) do
    Answer.changeset(answer, attrs)
  end
end
