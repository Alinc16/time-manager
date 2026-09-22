defmodule TimeManager.ManagementFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Management` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2026-09-20 19:57:00Z]
      })
      |> TimeManager.Management.create_clock()

    clock
  end

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~U[2026-09-20 19:57:00Z],
        start: ~U[2026-09-20 19:57:00Z]
      })
      |> TimeManager.Management.create_working_time()

    working_time
  end
end
