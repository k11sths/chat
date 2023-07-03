defmodule Chat.Rooms.Message do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :content, :string

    belongs_to(:users, Chat.Users.User,
      type: :binary_id,
      foreign_key: :user_id,
      references: :id
    )

    belongs_to(:rooms, Chat.Rooms.Room,
      type: :binary_id,
      foreign_key: :room_id,
      references: :id
    )

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :user_id, :room_id])
    |> validate_required([:content, :user_id, :room_id])
  end
end
