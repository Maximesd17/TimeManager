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
    if conn.method == "DELETE" do
      user_id = Map.get(conn.params, "userID")
      if user_id && GothamCityWeb.UserController.has_admin_role?(user_id) do
        conn
        |> put_status(403)  # Forbidden status code
        |> Plug.Conn.send_resp(403, "Forbidden, permission denied")
      else
        conn
      end
    else
      conn
    end
  end

  defp restrict_guest_access(conn) do
    conn
    |> put_status(401)  # Unauthorized status code
    |> Plug.Conn.send_resp(401, "Unauthorized perm denied")
  end
end
