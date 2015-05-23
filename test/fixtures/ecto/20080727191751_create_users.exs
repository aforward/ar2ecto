defmodule MyApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration
  def up do
    create table(:users) do
      add :created_at, :datetime
      add :updated_at, :datetime
      add :type, :string
      add :username, :string
      add :email, :string
      add :crypted_password, :string
      add :salt, :string
      add :destroyed_at, :datetime
      add :destroyed_by, :integer
    end
  end

  def down do
    drop table(:users)
  end
end
