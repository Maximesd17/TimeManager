defmodule GothamCityWeb.UserController do
  use GothamCityWeb, :controller

  alias GothamCity.Accounts
  alias GothamCity.Accounts.User
  alias GothamCity.Token

  action_fallback(GothamCityWeb.FallbackController)

  def identifier(conn, %{"username" => username, "email" => email}) do
    user = Accounts.get_user_by_username_and_email(username, email)
    render(conn, :show, user: user)
  end

  def create(conn, %{"user" => user_params}) do
    if not String.match?(user_params["email"], ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/) do
      conn
      |> put_status(:bad_request)
      |> put_view(html: GothamCityWeb.ErrorHTML, json: GothamCityWeb.ErrorJSON)
      |> render(:"400")
    end

    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      signer = Joken.Signer.create("HS256", "secret")

      extra_claims = %{user_id: user.id}
      {:ok, token, _claims} = Token.generate_and_sign(extra_claims, signer)
      {:ok, claims} = Token.verify_and_validate(token,signer)
      IO.inspect("#token #{token}")
      response =
        %{
          token: token,
          user: %{
            id: user.id,
            username: user.username,
            email: user.email
          }
        }

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> json(response)
    end
  end

  def show(conn, %{"userID" => id}) do
    signer = Joken.Signer.create("HS256", "secret")
    user = Accounts.get_user!(id)
    tokenList = get_req_header(conn, "authorization")
    token = Enum.join(tokenList)
    {:ok, claims} = Token.verify_and_validate(token,signer)

    IO.inspect(token)
    render(conn, :show, user: user)
  end

  def update(conn, %{"userID" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"userID" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
