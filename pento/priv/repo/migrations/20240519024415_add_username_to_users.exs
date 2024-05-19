defmodule Pento.Repo.Migrations.AddUsernameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:user_name, :string, null: false)
    end
  end
end
