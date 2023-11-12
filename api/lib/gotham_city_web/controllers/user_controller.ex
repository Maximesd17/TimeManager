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

  def teams(conn, _params) do
    if Enum.member?(conn.assigns.data.roles, "general_manager") ||
         Enum.member?(conn.assigns.data.roles, "administrator") do
      users = Accounts.list_users()
      render(conn, :index, users: users)
    else
      users = Accounts.list_users_team(conn.assigns.data.teams)
      render(conn, :index, users: users)
    end
  end

  def me(conn, _params) do
    conn
    |> put_status(:ok)
    |> put_resp_content_type("application/json")
    |> json(conn.assigns)
  end

  def me_update(conn, %{"user" => user_params}) do
    user = Accounts.get_user!(conn.assigns.data.id)
    IO.inspect(user_params)

    modifications = %{
      "email" => user_params["email"],
      "username" => user_params["username"]
    }

    with {:ok, %User{} = user} <- Accounts.update_user(user, modifications) do
      render(conn, :show, user: user)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    user = Accounts.get_user_by_email(email)

    case user do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> put_resp_content_type("application/json")
        |> send_resp(401, "User not found")

      _ ->
        password_in_db = user.password

        signer = Joken.Signer.create("HS256", "secret")
        current_time = System.system_time(:second)
        # 30 days
        expiration_time = current_time + 60 * 60 * 24 * 30

        token = user.token
        response = token_response_format(token)

        case Bcrypt.verify_pass(password, password_in_db) do
          true ->
            case Token.verify_and_validate(token, signer) do
              {:ok, claims} ->
                #                user_role_max = role_maximal(user.roles)
                #                IO.inspect(user_role_max)
                #                IO.inspect(has_admin_role?(user.id))
                conn
                |> put_status(:ok)
                |> put_resp_content_type("application/json")
                |> json(response)

              {:error, message} ->
                extra_claims = %{user_id: user.id, roles: user.roles, exp: expiration_time}
                {:ok, token, _claims} = Token.generate_and_sign(extra_claims, signer)

                newToken = %{"token" => token}
                response = token_response_format(token)
                Accounts.update_user(user, newToken)

                conn
                |> put_status(:ok)
                |> put_resp_content_type("application/json")
                |> json(response)
            end
            |> put_status(:ok)
            |> put_resp_content_type("application/json")
            |> json(response)

          false ->
            conn
            |> put_status(:unauthorized)
            |> put_resp_content_type("application/json")
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

    highest_role = role_maximal(conn.assigns.data.roles)
    user_params = Map.put_new(user_params, "roles", [])
    user_params = Map.put_new(user_params, "teams", [])

    if highest_role == "manager" do
      user_params = Map.put(user_params, "roles", [])
      user_params = Map.put(user_params, "teams", conn.assigns.data.teams)
    end

    if highest_role == "general_manager" do
      if "general_manager" in user_params.roles || "administrator" in user_params.roles do
        user_params = Map.put(user_params, "roles", [])
      end
    end

    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"userID" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"userID" => id, "user" => user_params}) do
    if !Enum.empty?(conn.assigns.data.roles) do
      user = Accounts.get_user!(id)
      highest_role = role_maximal(conn.assigns.data.roles)
      target_highest_role = role_maximal(user.roles)

      if highest_role == "administrator" do
        with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
          render(conn, :show, user: user)
        end
      end

      if highest_role == "general_manager" do
        if target_highest_role != "general_manager" && target_highest_role != "administrator" do
          with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
            render(conn, :show, user: user)
          end
        else
          send_resp(conn, :forbidden, "Forbidden, permission denied")
        end
      end

      if highest_role == "manager" do
        if target_highest_role == "employee" do
          with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
            render(conn, :show, user: user)
          end
        else
          send_resp(conn, :forbidden, "Forbidden, permission denied")
        end
      end
    else
      send_resp(conn, :forbidden, "Forbidden, permission denied")
    end
  end

  def delete(conn, %{"userID" => id}) do
    if !Enum.empty?(conn.assigns.data.roles) do
      user = Accounts.get_user!(id)
      highest_role = role_maximal(conn.assigns.data.roles)
      target_highest_role = role_maximal(user.roles)

      if highest_role == "administrator" do
        with {:ok, %User{}} <- Accounts.delete_user(user) do
          send_resp(conn, :no_content, "")
        end
      end

      if highest_role == "general_manager" do
        if target_highest_role != "general_manager" && target_highest_role != "administrator" do
          with {:ok, %User{}} <- Accounts.delete_user(user) do
            send_resp(conn, :no_content, "")
          end
        else
          send_resp(conn, :forbidden, "Forbidden, permission denied")
        end
      end

      if highest_role == "manager" do
        if target_highest_role == "employee" do
          with {:ok, %User{}} <- Accounts.delete_user(user) do
            send_resp(conn, :no_content, "")
          end
        else
          send_resp(conn, :forbidden, "Forbidden, permission denied")
        end
      end
    else
      send_resp(conn, :forbidden, "Forbidden, permission denied")
    end
  end

  def token_response_format(token) do
    %{
      data: %{token: token}
    }
  end

  defp role_maximal(roles) do
    roles_order = %{"manager" => 1, "general_manager" => 2, "administrator" => 3}

    role_values = fn role ->
      Map.get(roles_order, role, :unknown)
    end

    if Enum.empty?(roles) do
      "employee"
    else
      Enum.max_by(roles, &role_values.(&1))
    end
  end

  def has_admin_max_role?(id) do
    IO.inspect(Accounts.get_user!(id))

    case Accounts.get_user!(id) do
      %User{roles: roles} ->
        highest_role = role_maximal(roles)
        IO.inspect(highest_role)
        highest_role == "administrator"

      _ ->
        false
    end
  end
end
