defmodule ChatWeb.RoomControllerTest do
  use ChatWeb.ConnCase

  import Chat.RoomsFixtures

  @create_attrs %{name: "some name", owner_id: "some owner_id"}
  @update_attrs %{name: "some updated name", owner_id: "some updated owner_id"}
  @invalid_attrs %{name: nil, owner_id: nil}

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get(conn, ~p"/rooms")
      assert html_response(conn, 200) =~ "Listing Rooms"
    end
  end

  describe "new room" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/rooms/new")
      assert html_response(conn, 200) =~ "New Room"
    end
  end

  describe "create room" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/rooms", room: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/rooms/#{id}"

      conn = get(conn, ~p"/rooms/#{id}")
      assert html_response(conn, 200) =~ "Room #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/rooms", room: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Room"
    end
  end

  describe "edit room" do
    setup [:create]

    test "renders form for editing chosen room", %{conn: conn, room: room} do
      conn = get(conn, ~p"/rooms/#{room}/edit")
      assert html_response(conn, 200) =~ "Edit Room"
    end
  end

  describe "update room" do
    setup [:create]

    test "redirects when data is valid", %{conn: conn, room: room} do
      conn = put(conn, ~p"/rooms/#{room}", room: @update_attrs)
      assert redirected_to(conn) == ~p"/rooms/#{room}"

      conn = get(conn, ~p"/rooms/#{room}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, room: room} do
      conn = put(conn, ~p"/rooms/#{room}", room: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Room"
    end
  end

  describe "delete room" do
    setup [:create]

    test "deletes chosen room", %{conn: conn, room: room} do
      conn = delete(conn, ~p"/rooms/#{room}")
      assert redirected_to(conn) == ~p"/rooms"

      assert_error_sent 404, fn ->
        get(conn, ~p"/rooms/#{room}")
      end
    end
  end

  defp create(_) do
    room = room_fixture()
    %{room: room}
  end
end
