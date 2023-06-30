defmodule Chat.RoomsTest do
  use Chat.DataCase

  alias Chat.Rooms

  describe "rooms" do
    alias Chat.Rooms.Room

    import Chat.RoomsFixtures

    @invalid_attrs %{name: nil, owner_id: nil}

    test "list_all/0 returns all rooms" do
      room = room_fixture()
      assert Rooms.list_all() == [room]
    end

    test "get!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get!(room.id) == room
    end

    test "create/1 with valid data creates a room" do
      valid_attrs = %{name: "some name", owner_id: "some owner_id"}

      assert {:ok, %Room{} = room} = Rooms.create(valid_attrs)
      assert room.name == "some name"
      assert room.owner_id == "some owner_id"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{name: "some updated name", owner_id: "some updated owner_id"}

      assert {:ok, %Room{} = room} = Rooms.update(room, update_attrs)
      assert room.name == "some updated name"
      assert room.owner_id == "some updated owner_id"
    end

    test "update/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update(room, @invalid_attrs)
      assert room == Rooms.get!(room.id)
    end

    test "delete/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Rooms.delete(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end
end
