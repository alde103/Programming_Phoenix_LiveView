defmodule Pento.Repo.Migrations.CreateDemographics do
  use Ecto.Migration

  def change do
    create table(:demographics) do
      add :gender, :string
      add :year_of_birth, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:demographics, [:user_id])
  end
end
