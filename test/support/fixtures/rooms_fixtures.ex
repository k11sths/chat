defmodule Chat.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chat.Rooms` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    user = Chat.UsersFixtures.user_fixture()

    {:ok, room} =
      attrs
      |> Enum.into(%{
        name: "some name",
        owner_id: user.id
      })
      |> Chat.Rooms.create()

    room
  end

  def login_as_registered_user(%{conn: conn}) do
    user = Chat.UsersFixtures.user_fixture()

    conn = Plug.Conn.assign(conn, :current_user, user)
    {:ok, conn: conn}
  end
end
