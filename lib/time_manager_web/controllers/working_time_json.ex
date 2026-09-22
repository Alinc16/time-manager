defmodule TimeManagerWeb.WorkingTimeJSON do
  alias TimeManager.Management.WorkingTime

  def index(%{workingtime: workingtime}) do
    %{data: for(w <- workingtime, do: data(w))}
  end

  def show(%{working_time: working_time}) do
    %{data: data(working_time)}
  end

  defp data(%WorkingTime{} = working_time) do
    %{
      id: working_time.id,
      start: working_time.start,
      end: working_time.end,
      user: working_time.user_id
    }
  end
end