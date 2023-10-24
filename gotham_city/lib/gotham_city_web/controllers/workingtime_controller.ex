defmodule GothamCityWeb.WorkingtimeController do
  use GothamCityWeb, :controller

  alias GothamCity.Repo
  alias GothamCity.Accounts
  alias GothamCity.Accounts.Workingtime

  action_fallback(GothamCityWeb.FallbackController)

  def index(conn, %{"userID" => user_id, "start" => start_time, "end" => end_time}) do
    user = Accounts.get_user!(user_id)
    {:ok, start_datetime} = NaiveDateTime.from_iso8601(start_time)
    {:ok, end_datetime} = NaiveDateTime.from_iso8601(end_time)

    workingtimes = Accounts.get_workingtime_by_user_and_dates(user, start_datetime, end_datetime)
    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{"userID" => user_id, "workingtime" => workingtime_params}) do
    user = Accounts.get_user!(user_id)

    with {:ok, %Workingtime{} = workingtime} <-
           Accounts.create_workingtime(user, workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{workingtime}")
      |> render(:show, workingtime: workingtime)
    end
  end

  def show(conn, %{"id" => id, "userID" => user_id}) do
    user = Accounts.get_user!(user_id)
    workingtime = Accounts.get_workingtime_by_user(id, user)
    render(conn, :show, workingtime: workingtime)
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Accounts.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <-
           Accounts.update_workingtime(workingtime, workingtime_params) do
      render(conn, :show, workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Accounts.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Accounts.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end
end
