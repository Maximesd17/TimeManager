defmodule GothamCityWeb.ClockController do
  use GothamCityWeb, :controller

  alias GothamCity.Accounts
  alias GothamCity.Accounts.Clock

  action_fallback(GothamCityWeb.FallbackController)

  def show(conn, %{"userID" => user_id}) do
    user = Accounts.get_user!(user_id)
    clock = Accounts.get_clock_by_user(user)
    if clock do
      render(conn, :show, clock: clock)
    else
      send_resp(conn, :not_found, "Clock not found")
    end
  end

  def me(conn, _params) do
    user_id = conn.assigns.data.id
    user = Accounts.get_user!(user_id)
    clock = Accounts.get_clock_by_user(user)
    if clock do
    render(conn, :show, clock: clock)
    else
      send_resp(conn, :not_found, "Clock not found")
    end
  end

  def update_me(conn, _params) do
    user_id = conn.assigns.data.id

    now = NaiveDateTime.local_now()
    user = Accounts.get_user!(user_id)
    clock = Accounts.get_clock_by_user(user)
    manage_clock(conn, user, clock, now)
  end

  def update(conn, %{"userID" => user_id}) do
    user = Accounts.get_user!(user_id)
    now = NaiveDateTime.local_now()
    clock = Accounts.get_clock_by_user(user)

    manage_clock(conn, user, clock, now)
  end

  defp manage_clock(conn,user, clock, now) do
    if clock do
      if clock.status do
        with {:ok, %Clock{} = updated_clock} <-
               Accounts.update_clock(clock, %{"status" => false}) do
          Accounts.create_workingtime(user, %{"start" => clock.time, "end" => now})
          render(conn, :show, clock: updated_clock)
        end
      else
        with {:ok, %Clock{} = updated_clock} <-
               Accounts.update_clock(clock, %{"status" => true, "time" => now}) do
          render(conn, :show, clock: updated_clock)
        end
      end
    else
      with {:ok, %Clock{} = new_clock} <-
             Accounts.create_clock(user, %{"time" => now}) do
        render(conn, :show, clock: new_clock)
      end
    end
  end
end
