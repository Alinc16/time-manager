defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Management
  alias TimeManager.Management.Clock
  alias TimeManager.Repo
  import Ecto.Query

  action_fallback TimeManagerWeb.FallbackController

  # GET /api/clocks/:userID -> kullanıcının en son clock kaydını döner
  def show(conn, %{"userID" => user_id}) do
    query = from c in Clock,
      where: c.user_id == ^user_id,
      order_by: [desc: c.inserted_at],
      limit: 1

    case Repo.one(query) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "No clock found for this user"})

      %Clock{} = clock ->
        render(conn, :show, clock: clock)
    end
  end

  # POST /api/clocks/:userID -> hem girişi hem çıkışı otomatik yönetir
  def create(conn, %{"userID" => user_id} = params) do
    last_clock_query = from c in Clock,
      where: c.user_id == ^user_id,
      order_by: [desc: c.inserted_at],
      limit: 1

    last_clock = Repo.one(last_clock_query)

    new_status =
      if last_clock && last_clock.status == true do
        false
      else
        true
      end

    current_time = DateTime.utc_now() |> DateTime.truncate(:second)

    clock_params = Map.get(params, "clock", %{})
    time_val = Map.get(clock_params, "time", current_time)

    attrs = %{
      "user_id" => user_id,
      "status" => new_status,
      "time" => time_val
    }

    with {:ok, %Clock{} = clock} <- Management.create_clock(attrs) do
      conn
      |> put_status(:created)
      |> render(:show, clock: clock)
    end
  end
end
