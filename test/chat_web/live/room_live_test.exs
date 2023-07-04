defmodule ChatWeb.RoomLiveTest do
  @moduledoc false

  use ChatWeb.ConnCase

  import Phoenix.LiveViewTest
  import Chat.RoomsFixtures
  import Chat.MessageFixtures
  import Chat.UsersFixtures

  setup do
    %{user: user_fixture(), room: room_fixture()}
  end

  describe "Join room" do
    test "renders join room page", %{conn: conn, user: user, room: room} do
      {:ok, lv, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/rooms/#{room.id}")

      rendered_live_view = render(lv)

      assert html =~ "Chatting in "
      assert html =~ room.name
      assert rendered_live_view =~ "system:"
      assert rendered_live_view =~ "#{user.username} joined the chat"
    end

    test "renders join room page and loads all the previous messages", %{
      conn: conn,
      user: user,
      room: room
    } do
      message = message_fixture(%{room_id: room.id})

      {:ok, lv, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/rooms/#{room.id}")

      rendered_live_view = render(lv)

      assert html =~ "Chatting in "
      assert html =~ room.name
      assert rendered_live_view =~ "system:"
      assert rendered_live_view =~ "#{user.username} joined the chat"
      assert rendered_live_view =~ "#{user.username}:"
      assert rendered_live_view =~ message.content
    end

    test "redirects to main lobby if you try to join the room multiple times", %{
      conn: conn,
      user: user,
      room: room
    } do
      {:ok, lv, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/rooms/#{room.id}")

      rendered_live_view = render(lv)

      assert html =~ "Chatting in "
      assert html =~ room.name
      assert rendered_live_view =~ "system:"
      assert rendered_live_view =~ "#{user.username} joined the chat"

      {:ok, conn} =
        conn
        |> log_in_user(user)
        |> live(~p"/rooms/#{room.id}")
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "You are already in the room with another session."
    end
  end

  describe "Send message in a room and append in the message list" do
    test "renders join room page and loads all the previous messages", %{
      conn: conn,
      user: user,
      room: room
    } do
      message = message_fixture(%{room_id: room.id})

      {:ok, lv, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/rooms/#{room.id}")

      rendered_live_view = render(lv)

      assert html =~ "Chatting in "
      assert html =~ room.name
      assert rendered_live_view =~ "system:"
      assert rendered_live_view =~ "#{user.username} joined the chat"
      assert rendered_live_view =~ "#{user.username}:"
      assert rendered_live_view =~ message.content

      lv
      |> form("#chat_form", %{"message" => "This is a new test message"})
      |> render_submit()

      rendered_live_view = render(lv)

      assert rendered_live_view =~ "#{user.username}:"
      assert rendered_live_view =~ "This is a new test message"
    end
  end
end
