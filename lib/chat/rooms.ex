defmodule Chat.Rooms do
  @moduledoc """
  The Rooms context.
  """

  import Ecto.Query, warn: false
  alias Chat.Repo

  alias Chat.Rooms.Room

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_all()
      [%Room{}, ...]

  """
  def list_all(preloads \\ []), do: Room |> Repo.all() |> Repo.preload(preloads)

  @doc """
  Returns the list of all user's rooms.

  ## Examples

      iex> list_all_by_user_id(user_id)
      [%Room{}, ...]

  """
  def list_all_by_user_id(user_id, preloads \\ []) do
    from(
      r in Room,
      where: r.owner_id == ^user_id,
      order_by: [desc: :inserted_at]
    )
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get!(123)
      %Room{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id, preloads \\ []), do: Room |> Repo.get!(id) |> Repo.preload(preloads)

  @doc """
  Gets a single room or returns nil.

  ## Examples

      iex> get(123)
      %Room{}

      iex> get(456)
      nil

  """
  def get(id, preloads \\ []), do: Room |> Repo.get(id) |> Repo.preload(preloads)

  @doc """
  Fetches a single room or returns an error tuple.

  ## Examples

      iex> fetch(123)
      {:ok, %Room{}}

      iex> get(456)
      {:error, :not_found}

  """
  def fetch(id, preloads \\ []) do
    case get(id, preloads) do
      nil -> {:error, :not_found}
      room -> {:ok, room}
    end
  end

  @doc """
  Creates a room.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Room{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a room.

  ## Examples

      iex> delete(room)
      {:ok, %Room{}}

      iex> delete(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{data: %Room{}}

  """
  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end
end
