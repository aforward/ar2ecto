defmodule MyApp.Repo.Migrations.CreateSessions do
  use Ecto.Migration
  def up do
    create table(:sessions) do
      add :session_id, :string
      add :data, :text
      timestamps
    end
  end

  def down do
    drop table(:sessions)
  end
end
