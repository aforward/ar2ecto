defmodule Ar2ecto.Line do

  def parse(nil), do: %{type: :unknown, line: nil}
  def parse(line) do
    cond do
      match = Regex.run(~r{.*class\s*([^\s]*)\s*<\s*ActiveRecord::Migration.*}, line) ->
        [_, name] = match
        %{type: :defmodule, name: name}
      match = Regex.run(~r{def\s*self\.(up|down|change)}, line) ->
        [_, direction] = match
        %{type: String.to_atom(direction)}

      match = Regex.run(~r{create_table \"([^\"]*)\"}, line) ->
        [_, name] = match
        %{type: :create_table, name: String.to_atom(name)}

      match = Regex.run(~r{create_table :([^\s]*)}, line) ->
        [_, name] = match
        %{type: :create_table, name: String.to_atom(name)}

      match = Regex.run(~r{[^\s]*\.([^\s]*) :([^\s]*)}, line) ->
        [_, format, name] = match
        %{type: :add_field, name: String.to_atom(name), format: String.to_atom(format)}
      match = Regex.run(~r{\s*end\s*}, line) ->
        [_] = match
        %{type: :end, line: line}

      true ->
        %{type: :unknown, line: line}
    end
  end

  def render(parsed, app_name) do
    case parsed[:type] do
      :defmodule -> "defmodule #{app_name}.Repo.Migrations.#{parsed[:name]} do\n  use Ecto.Migration"
      :up -> "  def up do"
      :down -> "  def down do"
      :change -> "  def change do"
      :create_table -> "    create table(:#{parsed[:name]}) do"
      :add_field -> "      add :#{parsed[:name]}, :#{parsed[:format]}"
      :end -> parsed[:line]
      :unknown -> parsed[:line]
    end
  end


end