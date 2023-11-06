defmodule GothamCityWeb.JwtAuthPlug do
  alias GothamCity.Accounts
  alias GothamCity.Token
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    token = get_token_from_header(conn)
    signer = Joken.Signer.create("HS256", "secret")
    {:ok, claims} = Token.verify_and_validate(token, signer)
    user = is_user_exist(claims)
    case Token.verify_and_validate(token, signer) do
      {:ok, _claims} ->
        conn
      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> Plug.Conn.send_resp(401, Jason.encode!(message))
    end
  end

  defp get_token_from_header(conn) do
    tokenList = get_req_header(conn, "authorization")
    Enum.join(tokenList, " ")
  end

  def is_user_exist(claims) do
    user_id = Map.get(claims, "user_id")
    Accounts.get_user!(user_id)
  end
end
