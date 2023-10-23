defmodule GothamCityWeb.WorkingtimeController do
  use GothamCityWeb, :controller

  alias GothamCity.Accounts
  alias GothamCity.Accounts.Workingtime

  action_fallback GothamCityWeb.FallbackController

  def index(conn, _params) do
    workingtimes = Accounts.list_workingtimes()
    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{"workingtime" => workingtime_params}) do
    with {:ok, %Workingtime{} = workingtime} <- Accounts.create_workingtime(workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{workingtime}")
      |> render(:show, workingtime: workingtime)
    end
  end

  def show(conn, %{"id" => id}) do
    workingtime = Accounts.get_workingtime!(id)
    render(conn, :show, workingtime: workingtime)
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Accounts.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <- Accounts.update_workingtime(workingtime, workingtime_params) do
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
