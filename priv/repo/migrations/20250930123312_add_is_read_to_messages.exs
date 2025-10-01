defmodule SafitechBackend.Repo.Migrations.AddIsReadToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :is_read, :boolean, default: false, null: false
    end
  end
end
