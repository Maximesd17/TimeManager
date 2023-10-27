defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Users
  alias TimeManager.Clocks
  alias TimeManager.Clocks.Clock

  action_fallback TimeManagerWeb.FallbackController

def show(conn, %{"userID" => user_id}) do
    user = Users.get_user!(user_id)
    clock = Clocks.get_clock_by_user(user)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Clocks.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end
end
