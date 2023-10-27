defmodule TimeManager.WorkingTimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.WorkingTime` context.
  """

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: ~N[2023-10-22 19:26:00],
        start: ~N[2023-10-22 19:26:00]
      })
      |> TimeManager.WorkingTime.create_workingtime()

    workingtime
  end
end
