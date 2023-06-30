defmodule ChatWeb.RoomController do
  use ChatWeb, :controller

  alias Chat.Rooms
  alias Chat.Rooms.Room

  def index(conn, _params) do
    rooms = Rooms.list_all()
    render(conn, :index, rooms: rooms)
  end

  def my_rooms(conn, _params) do
    rooms =
      conn
      |> ChatWeb.Utils.current_user_id()
      |> Rooms.list_all_by_user_id()

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
      |> Rooms.create()

    case result do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Room created successfully.")
        |> redirect(to: ~p"/rooms/my-rooms")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Rooms.fetch(id) do
      {:ok, room} ->
        render(conn, :show, room: room)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Room not found"})
    end
  end

  def edit(conn, %{"id" => id}) do
    case Rooms.fetch(id) do
      {:ok, room} ->
        changeset = Rooms.change_room(room)
        render(conn, :edit, room: room, changeset: changeset)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Room not found"})
    end
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    case Rooms.fetch(id) do
      {:ok, room} ->
        case Rooms.update(room, room_params) do
          {:ok, _} ->
            conn
            |> put_flash(:info, "Room updated successfully.")
            |> redirect(to: ~p"/rooms/my-rooms")

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, :edit, room: room, changeset: changeset)
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Room not found"})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Rooms.fetch(id) do
      {:ok, room} ->
        case Rooms.delete(room) do
          {:ok, _room} ->
            conn
            |> put_flash(:info, "Room deleted successfully.")
            |> redirect(to: ~p"/rooms/my-rooms")

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, :delete, room: room, changeset: changeset)
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Room not found"})
    end
  end
end
