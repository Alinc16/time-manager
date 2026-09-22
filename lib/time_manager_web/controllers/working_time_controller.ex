defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Management
  alias TimeManager.Management.WorkingTime
  alias TimeManager.Repo
  import Ecto.Query

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"userID" => user_id} = params) do
    start_time = params["start"]
    end_time = params["end"]

    query = from w in WorkingTime, where: w.user_id == ^user_id

    query =
      if start_time do
        case DateTime.from_iso8601(start_time) do
          {:ok, dt, _} -> where(query, [w], w.start >= ^dt)
          _ -> query
        end
      else
        query
      end

    query =
      if end_time do
        case DateTime.from_iso8601(end_time) do
          {:ok, dt, _} -> where(query, [w], w.end <= ^dt)
          _ -> query
        end
      else
        query
      end

    workingtimes = Repo.all(query)
    render(conn, :index, workingtime: workingtimes)
  end

  def create(conn, %{"userID" => user_id} = params) do
    working_time_params = Map.get(params, "working_time", params)
    attrs = Map.put(working_time_params, "user_id", user_id)

    with {:ok, %WorkingTime{} = working_time} <- Management.create_working_time(attrs) do
      conn
      |> put_status(:created)
      |> render(:show, working_time: working_time)
    end
  end

  def show(conn, %{"userID" => user_id, "id" => id}) do
    working_time = Repo.get_by!(WorkingTime, id: id, user_id: user_id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id} = params) do
    working_time = Management.get_working_time!(id)
    working_time_params = Map.get(params, "working_time", params)

    with {:ok, %WorkingTime{} = working_time} <- Management.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Management.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Management.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end