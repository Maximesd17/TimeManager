defmodule GothamCityWeb.JwtAuthPlug do
  alias GothamCity.Accounts
  alias GothamCity.Token
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    token = get_token_from_header(conn)
    signer = Joken.Signer.create("HS256", "secret")

    case Token.verify_and_validate(token, signer) do
      {:ok, claims} ->
        user = is_user_exist(claims)
        user_id = Map.get(claims, "user_id")
        req_user = user_response(user)
        case user do
          user ->
            conn
            |> assign(:data, req_user)
          {:error, message} ->
            conn
            |> put_status(:unauthorized)
            |> Plug.Conn.send_resp(401, Jason.encode!(message))
        end
      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> Plug.Conn.send_resp(401, Jason.encode!(message))
    end
  end

  defp get_token_from_header(conn) do
    tokenList = get_req_header(conn, "authorization")
    token = Enum.join(tokenList, " ")

    tokenSplit = String.split(token, " ")
    case Enum.at(tokenSplit, 0) === "Bearer" do
      true ->
        case Enum.at(tokenSplit, 1)  !== nil do
          true ->
            Enum.at(tokenSplit, 1)
          false ->
            conn
            |> put_status(:unauthorized)
            |> put_resp_content_type("application/json")
            |> send_resp(401, "Unauthorized")
        end
      false ->
        conn
        |> put_status(:unauthorized)
        |> put_resp_content_type("application/json")
        |> send_resp(401, "Unauthorized")
    end
  end

  def is_user_exist(claims) do
    user_id = Map.get(claims, "user_id")
    Accounts.get_user!(user_id)
  end

  def user_response(user)do
     %{
        id: user.id,
        username: user.username,
        email: user.email,
        roles: user.roles,
        teams: user.teams
      }
  end
end
