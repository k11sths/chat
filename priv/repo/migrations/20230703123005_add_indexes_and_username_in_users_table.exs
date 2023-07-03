defmodule Chat.Repo.Migrations.AddIndexesAndUsernameInUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string, null: false, default: "test-user"
    end

    create index(:messages, [:room_id])
    create index(:rooms, [:owner_id])
  end
end
