defmodule ChatWeb.RoomController do
  use ChatWeb, :controller

  alias Chat.Rooms
  alias Chat.Rooms.Room

  def index(conn, _params) do
    rooms = Rooms.list_rooms()
    render(conn, :index, rooms: rooms)
  end

  def my_rooms(conn, _params) do
    rooms =
      conn
      |> ChatWeb.Utils.current_user_id()
      |> Rooms.list_rooms_by_user_id()

    render(conn, :my_rooms, rooms: rooms)
  end

  def new(conn, _params) do
    changeset = Rooms.change_room(%Room{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    user_id = ChatWeb.Utils.current_user_id(conn)

    result =
      room_params
      |> Map.put("owner_id", user_id)
      |> Rooms.create_room()

    case result do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Room created successfully.")
        |> redirect(to: ~p"/rooms/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Rooms.get_room!(id)
    render(conn, :show, room: room)
  end

  def edit(conn, %{"id" => id}) do
    room = Rooms.get_room!(id)
    changeset = Rooms.change_room(room)
    render(conn, :edit, room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Rooms.get_room!(id)

    case Rooms.update_room(room, room_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Room updated successfully.")
        |> redirect(to: ~p"/rooms")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, room: room, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Rooms.get_room!(id)
    {:ok, _room} = Rooms.delete_room(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> redirect(to: ~p"/rooms")
  end
end
