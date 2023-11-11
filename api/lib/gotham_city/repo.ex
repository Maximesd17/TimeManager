defmodule GothamCity.Repo do
  use Ecto.Repo,
    otp_app: :gotham_city,
    adapter: Ecto.Adapters.Postgres
end
