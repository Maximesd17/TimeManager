defmodule GothamCityWeb.RoutePermissionsPlug do
  import Plug.Conn
  alias GothamCityWeb.UserController

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
#    user = conn.assigns[:current_user]
#
#    case user do
#      %{"roles" => roles} ->
#        max_role = GothamCityWeb.UserController.role_maximal(roles)
#
#        case max_role do
#          # administrator can have access to all routes
#          :administrator -> conn |> restrict_general_manager_access
#          :general_manager -> conn |> restrict_general_manager_access
#          :manager -> conn |> restrict_general_manager_access
#          _ -> conn |> restrict_general_manager_access
#        end
#
#      _ -> conn |> restrict_general_manager_access
#    end
    conn |> restrict_general_manager_access
  end

  defp restrict_general_manager_access(conn) do
    IO.inspect(conn)
    if conn.method !== "DELETE" && conn.method !== "PUT" do
      conn
      |> put_status(401)
      |> Plug.Conn.send_resp(401, "Unauthorized, permission denied")
    end

    # general manager cannot delete admin
    if conn.method == "DELETE" do
      user_id = Map.get(conn.params, "userID")
      if user_id && GothamCityWeb.UserController.has_admin_max_role?(user_id) do
        conn
        |> put_status(403)  # Forbidden status code
        |> Plug.Conn.send_resp(403, "Forbidden, permission denied")
      else
        conn
      end
    else
      conn
    end

    # promote employee to manager
    if conn.method == "PUT" do
      user_id = Map.get(conn.params, "userID")
      update_role = Map.get(conn.body_params, "roles")
      IO.inspect(user_id)
      IO.inspect(update_role)


      if user_id && GothamCityWeb.UserController.role_maximal(conn.assigns.data.roles) === [] && update_role === ["manager"]do
        #          il faut trouver un moyen pour acceder a la valeur ["manager"] de body_params
        #          body_params: %{"user" => %{"roles" => ["manager"]}},
        #          pour dire que general manager peut SEULEMENT promote employee -> manager
        #         (ex: general manager ne peut pas promote un employe a admin)

            conn
      else
        conn
        |> put_status(403)  # Forbidden status code
        |> Plug.Conn.send_resp(403, "Forbidden, permission denied")
      end
    end

  end


  defp restrict_manager_access(conn) do

  end

  defp restrict_employee_access(conn) do
    user_id = Map.get(conn.params, "userID")

  end

  defp restrict_guest_access(conn) do
    conn
    |> put_status(401)
    |> Plug.Conn.send_resp(401, "Unauthorized perm denied")
  end
end
