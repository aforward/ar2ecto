defmodule MyApp.Repo.Migrations.AddWebsitesTheme do
  use Ecto.Migration
  def up do
    alter table(:websites) do
      add :theme, :string, default: nil
    end
  end

  def down do
    alter table(:websites) do
      remove :theme
    end
  end
end
