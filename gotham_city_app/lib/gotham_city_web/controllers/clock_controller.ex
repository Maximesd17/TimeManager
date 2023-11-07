defmodule GothamCityWeb.ClockController do
  use GothamCityWeb, :controller

  alias GothamCity.Accounts
  alias GothamCity.Accounts.Clock

  action_fallback(GothamCityWeb.FallbackController)

  def show(conn, %{"userID" => user_id}) do
    user = Accounts.get_user!(user_id)
    clock = Accounts.get_clock_by_user(user)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"userID" => user_id}) do
    user = Accounts.get_user!(user_id)
    now = NaiveDateTime.local_now()
    clock = Accounts.get_clock_by_user(user)

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
