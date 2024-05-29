defmodule Pento.Repo.Migrations.CreateAnswer do
  use Ecto.Migration

  def change do
    create table(:answer) do
      add :answer, :string
      add :votes, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :faq_id, references(:faqs, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:answer, [:user_id])
    create index(:answer, [:faq_id])
  end
end
