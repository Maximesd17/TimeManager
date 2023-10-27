defmodule TimeManagerWeb.WorkingtimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.WorkingTime
  alias TimeManager.WorkingTime.Workingtime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    workingtimes = WorkingTime.list_workingtimes()
    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{"workingtime" => workingtime_params}) do
    with {:ok, %Workingtime{} = workingtime} <- WorkingTime.create_workingtime(workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{workingtime}")
      |> render(:show, workingtime: workingtime)
    end
  end

  def show(conn, %{"id" => id}) do
    workingtime = WorkingTime.get_workingtime!(id)
    render(conn, :show, workingtime: workingtime)
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = WorkingTime.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <- WorkingTime.update_workingtime(workingtime, workingtime_params) do
      render(conn, :show, workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = WorkingTime.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- WorkingTime.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end
end
