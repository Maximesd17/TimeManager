defmodule GothamCity.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password, :string)
    field(:roles, {:array, :string})
    field(:teams, {:array, :string})
    field(:token, :string)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :roles, :teams, :token])
    |> validate_required([:username, :email, :password])
    |> hash_password()
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password ->
        hashed_password = Bcrypt.hash_pwd_salt(password)
        put_change(changeset, :password, hashed_password)
    end
  end

end
