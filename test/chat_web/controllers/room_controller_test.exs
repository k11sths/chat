defmodule ChatWeb.RoomControllerTest do
  use ChatWeb.ConnCase

  import Chat.RoomsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  setup [:login_as_registered_user]

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get(conn, ~p"/")
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
    test "redirects to list when data is valid", %{conn: conn} do
      response = post(conn, ~p"/rooms", room: @create_attrs)

      assert redirected_to(response) == ~p"/rooms/my-rooms"

      response = get(conn, ~p"/")
      assert html_response(response, 200) =~ "Room"
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
      response = put(conn, ~p"/rooms/#{room}", room: @update_attrs)
      assert redirected_to(response) == ~p"/rooms/my-rooms"

      response = get(conn, ~p"/")
      assert html_response(response, 200) =~ "some updated name"
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
      assert redirected_to(conn) == ~p"/rooms/my-rooms"

      conn = get(conn, ~p"/rooms/#{room}/edit")
      assert json_response(conn, 404) == %{"error" => "Room not found"}
    end
  end

  defp create(_) do
    room = room_fixture()
    %{room: room}
  end
end
