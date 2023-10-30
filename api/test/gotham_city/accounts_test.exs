defmodule GothamCity.AccountsTest do
  use GothamCity.DataCase

  alias GothamCity.Accounts

  describe "users" do
    alias GothamCity.Accounts.User

    import GothamCity.AccountsFixtures

    @invalid_attrs %{username: nil, email: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{username: "some username", email: "some email"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.username == "some username"
      assert user.email == "some email"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{username: "some updated username", email: "some updated email"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.username == "some updated username"
      assert user.email == "some updated email"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "clocks" do
    alias GothamCity.Accounts.Clock

    import GothamCity.AccountsFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Accounts.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Accounts.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      valid_attrs = %{status: true, time: ~N[2023-10-22 17:27:00]}

      assert {:ok, %Clock{} = clock} = Accounts.create_clock(valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2023-10-22 17:27:00]
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{status: false, time: ~N[2023-10-23 17:27:00]}

      assert {:ok, %Clock{} = clock} = Accounts.update_clock(clock, update_attrs)
      assert clock.status == false
      assert clock.time == ~N[2023-10-23 17:27:00]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_clock(clock, @invalid_attrs)
      assert clock == Accounts.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Accounts.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Accounts.change_clock(clock)
    end
  end

  describe "workingtimes" do
    alias GothamCity.Accounts.Workingtime

    import GothamCity.AccountsFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      workingtime = workingtime_fixture()
      assert Accounts.list_workingtimes() == [workingtime]
    end

    test "get_workingtime!/1 returns the workingtime with given id" do
      workingtime = workingtime_fixture()
      assert Accounts.get_workingtime!(workingtime.id) == workingtime
    end

    test "create_workingtime/1 with valid data creates a workingtime" do
      valid_attrs = %{start: ~N[2023-10-22 17:31:00], end: ~N[2023-10-22 17:31:00]}

      assert {:ok, %Workingtime{} = workingtime} = Accounts.create_workingtime(valid_attrs)
      assert workingtime.start == ~N[2023-10-22 17:31:00]
      assert workingtime.end == ~N[2023-10-22 17:31:00]
    end

    test "create_workingtime/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_workingtime(@invalid_attrs)
    end

    test "update_workingtime/2 with valid data updates the workingtime" do
      workingtime = workingtime_fixture()
      update_attrs = %{start: ~N[2023-10-23 17:31:00], end: ~N[2023-10-23 17:31:00]}

      assert {:ok, %Workingtime{} = workingtime} = Accounts.update_workingtime(workingtime, update_attrs)
      assert workingtime.start == ~N[2023-10-23 17:31:00]
      assert workingtime.end == ~N[2023-10-23 17:31:00]
    end

    test "update_workingtime/2 with invalid data returns error changeset" do
      workingtime = workingtime_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_workingtime(workingtime, @invalid_attrs)
      assert workingtime == Accounts.get_workingtime!(workingtime.id)
    end

    test "delete_workingtime/1 deletes the workingtime" do
      workingtime = workingtime_fixture()
      assert {:ok, %Workingtime{}} = Accounts.delete_workingtime(workingtime)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_workingtime!(workingtime.id) end
    end

    test "change_workingtime/1 returns a workingtime changeset" do
      workingtime = workingtime_fixture()
      assert %Ecto.Changeset{} = Accounts.change_workingtime(workingtime)
    end
  end
end
