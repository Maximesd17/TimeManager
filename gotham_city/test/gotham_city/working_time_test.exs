defmodule TimeManager.WorkingTimeTest do
  use TimeManager.DataCase

  alias TimeManager.WorkingTime

  describe "workingtimes" do
    alias TimeManager.WorkingTime.Workingtime

    import TimeManager.WorkingTimeFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      workingtime = workingtime_fixture()
      assert WorkingTime.list_workingtimes() == [workingtime]
    end

    test "get_workingtime!/1 returns the workingtime with given id" do
      workingtime = workingtime_fixture()
      assert WorkingTime.get_workingtime!(workingtime.id) == workingtime
    end

    test "create_workingtime/1 with valid data creates a workingtime" do
      valid_attrs = %{end: ~N[2023-10-22 19:26:00], start: ~N[2023-10-22 19:26:00]}

      assert {:ok, %Workingtime{} = workingtime} = WorkingTime.create_workingtime(valid_attrs)
      assert workingtime.end == ~N[2023-10-22 19:26:00]
      assert workingtime.start == ~N[2023-10-22 19:26:00]
    end

    test "create_workingtime/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkingTime.create_workingtime(@invalid_attrs)
    end

    test "update_workingtime/2 with valid data updates the workingtime" do
      workingtime = workingtime_fixture()
      update_attrs = %{end: ~N[2023-10-23 19:26:00], start: ~N[2023-10-23 19:26:00]}

      assert {:ok, %Workingtime{} = workingtime} = WorkingTime.update_workingtime(workingtime, update_attrs)
      assert workingtime.end == ~N[2023-10-23 19:26:00]
      assert workingtime.start == ~N[2023-10-23 19:26:00]
    end

    test "update_workingtime/2 with invalid data returns error changeset" do
      workingtime = workingtime_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkingTime.update_workingtime(workingtime, @invalid_attrs)
      assert workingtime == WorkingTime.get_workingtime!(workingtime.id)
    end

    test "delete_workingtime/1 deletes the workingtime" do
      workingtime = workingtime_fixture()
      assert {:ok, %Workingtime{}} = WorkingTime.delete_workingtime(workingtime)
      assert_raise Ecto.NoResultsError, fn -> WorkingTime.get_workingtime!(workingtime.id) end
    end

    test "change_workingtime/1 returns a workingtime changeset" do
      workingtime = workingtime_fixture()
      assert %Ecto.Changeset{} = WorkingTime.change_workingtime(workingtime)
    end
  end
end
