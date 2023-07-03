defmodule Chat.Repo.Migrations.CreateMessagesTable do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :room_id, references(:rooms, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
  end
end
