defmodule Chat.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :owner_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
