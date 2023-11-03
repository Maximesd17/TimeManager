defmodule GothamCity.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false
      add :roles, {:array, :string}, default: []

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])

    execute("ALTER TABLE users ADD CONSTRAINT email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')")
  end
end
