defmodule GothamCity.Repo.Migrations.CreateWorkingtimes do
  use Ecto.Migration

  def change do
    create table(:workingtimes) do
      add :start, :utc_datetime_usec, null: false
      add :end, :utc_datetime_usec, null: false
      add :user, references(:users, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:workingtimes, [:user])
  end
end
