defmodule Chat.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false

  alias Chat.Repo

  alias Chat.Rooms.Message

  def all_by_room_id(room_id, preloads \\ []) do
    from(
      m in Message,
      where: m.room_id == ^room_id,
      order_by: [desc: :inserted_at],
      limit: 20
    )
    |> Repo.all()
    |> Repo.preload(preloads)
    |> Enum.reverse()
  end

  def create(content, user_id, room_id, preloads \\ []) do
    result =
      %Message{}
      |> Message.changeset(%{
        content: content,
        user_id: user_id,
        room_id: room_id
      })
      |> Repo.insert()

    case result do
      {:ok, message} -> {:ok, Repo.preload(message, preloads)}
      error -> error
    end
  end

  def delete_all_by_room_id(room_id),
    do: Repo.delete_all(from(m in Message, where: m.room_id == ^room_id))
end
