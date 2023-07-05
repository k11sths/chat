defmodule Chat.MessagesTest do
  use Chat.DataCase

  alias Chat.Messages

  describe "messages" do
    alias Chat.Rooms.Message

    import Chat.RoomsFixtures
    import Chat.UsersFixtures
    import Chat.MessageFixtures

    test "all_by_room_id/1 returns all messages from a room" do
      %{room_id: room_id_1} = message_1 = message_fixture()
      _message_2 = message_fixture()
      message_3 = message_fixture(%{room_id: room_id_1})
      assert Messages.all_by_room_id(room_id_1) == [message_3, message_1]
    end

    test "delete_all_by_room_id/1 deletes all messages from a room" do
      %{room_id: room_id_1} = message_fixture()
      %{room_id: room_id_2} = message_2 = message_fixture()
      _message_3 = message_fixture(%{room_id: room_id_1})
      assert Messages.delete_all_by_room_id(room_id_1) == {2, nil}
      assert Messages.all_by_room_id(room_id_1) == []
      assert Messages.all_by_room_id(room_id_2) == [message_2]
    end

    test "create/3 with valid data creates a message" do
      room = room_fixture()
      user = user_fixture()

      content = "some message"
      user_id = user.id
      room_id = room.id
      assert {:ok, %Message{} = message} = Chat.Messages.create(content, user_id, room_id)
      assert message.content == "some message"
      assert message.user_id == user_id
      assert message.room_id == room_id
    end

    test "create/3 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create("some message", nil, nil)
    end
  end
end
