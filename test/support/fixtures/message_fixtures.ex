defmodule Chat.MessageFixtures do
  @moduledoc false

  def message_fixture(attrs \\ %{}) do
    room = Chat.RoomsFixtures.room_fixture()
    user = Chat.UsersFixtures.user_fixture()

    content = attrs[:content] || "some message"
    user_id = attrs[:user_id] || user.id
    room_id = attrs[:room_id] || room.id
    {:ok, message} = Chat.Messages.create(content, user_id, room_id)

    message
  end
end
