defmodule Mix.Tasks.Ar2ecto do

  use Mix.Task
  @shortdoc "Tranform AR migrations to Ecto migrations"

  @moduledoc """
  This task will transform your active record migrations (.rb)
  Into Ecto migrations (.exs).

  For example,

  ```
  mix ar2ecto MyApp ./path/to/oldapp/db/migrate ./path/to/newapp/priv/repo/migrations
  ```

  Please report any bugs to aforward@gmail.com
  """
  def run(inputs) do
    [app_name, active_record_path, ecto_path] = inputs
    IO.puts "Migrating #{app_name} from ActiveRecord to Ecto..."
    IO.puts "  -- Looking for migrations in #{active_record_path}"
    IO.puts "  -- Migrating to #{ecto_path}"
    Ar2ecto.Parser.parse(app_name, active_record_path, ecto_path)
    IO.puts "DONE, Migrating from ActiveRecord to Ecto."
  end
end