defmodule Pento.Repo.Migrations.CreateFaqs do
  use Ecto.Migration

  def change do
    create table(:faqs) do
      add :question, :string

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:faqs, [:question]))
  end
end
