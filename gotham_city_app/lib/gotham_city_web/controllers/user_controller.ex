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

  def me(conn) do
    IO.inspect(conn)
  end

  def login(conn, %{"email" => email, "password" => password}) do
    user = Accounts.get_user_by_email(email)

    case user do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> put_resp_content_type("text/plain")
        |> send_resp(401, "User not found")

      _ ->
        password_in_db = user.password

        signer = Joken.Signer.create("HS256", "secret")
        current_time = System.system_time(:second)
        expiration_time = current_time + 60 * 60 * 24 * 30  # 30 days

        token = user.token
        response = token_response_format(token)
        case Bcrypt.verify_pass(password, password_in_db) do
          true ->
            case Token.verify_and_validate(token, signer) do
              {:ok, claims} ->
                conn
                |> put_status(:ok)
                |> put_resp_content_type("text/plain")
                |> json(response)
              {:error, message} ->
                extra_claims = %{user_id: user.id, exp: expiration_time}
                {:ok, token, _claims} = Token.generate_and_sign(extra_claims, signer)

                newToken = %{"token" => token}
                response = token_response_format(token)
                Accounts.update_user(user, newToken)
                conn
                  |> put_status(:ok)
                  |> put_resp_content_type("text/plain")
                  |> json(response)
            end
            |> put_status(:ok)
            |> put_resp_content_type("text/plain")
            |> json(response)

          false ->
            conn
            |> put_status(:unauthorized)
            |> put_resp_content_type("text/plain")
            |> send_resp(401, "Invalid username or password")
        end
    end
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
      current_time = System.system_time(:second)
      expiration_time = current_time + 60 * 60 * 24 * 30  # 30 days

      extra_claims = %{user_id: user.id, exp: expiration_time}

      {:ok, token, _claims} = Token.generate_and_sign(extra_claims, signer)
      {:ok, claims} = Token.verify_and_validate(token, signer)
      tokenUser = %{"token" => token}
      Accounts.update_user(user, tokenUser)
      response = token_response_format(token)
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> json(response)
    end
  end

  def show(conn, %{"userID" => id}) do
    user = Accounts.get_user!(id)
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

  def token_response_format(token) do
    %{
      data: %{token: token}
    }
  end
end
