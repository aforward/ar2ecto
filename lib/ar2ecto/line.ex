defmodule Ar2ecto.Line do

  def tokenize(nil), do: %{type: :unknown, line: nil}
  def tokenize(line) do
    cond do
      match = Regex.run(~r{.*class\s*([^\s]*)\s*<\s*ActiveRecord::Migration.*}, line) ->
        [_, name] = match
        %{type: :defmodule, name: name}

      match = Regex.run(~r{def\s*self\.(up|down|change)}, line) ->
        [_, direction] = match
        %{type: String.to_atom(direction)}

      match = Regex.run(~r{(create_table|drop_table) \"([^\"]*)\"}, line) ->
        [_, operation, name] = match
        %{type: String.to_atom(operation), name: String.to_atom(name)}

      match = Regex.run(~r{(create_table|drop_table) :([^\s]*)}, line) ->
        [_, operation, name] = match
        %{type: String.to_atom(operation), name: String.to_atom(name)}

      match = Regex.run(~r{[^\s]*\.([^\s]*)\s*:([^\s,]*)}, line) ->
        [_, format, name] = match
        %{type: :add_field, name: String.to_atom(name), format: String.to_atom(format)}

      match = Regex.run(~r{\s*end\s*}, line) ->
        [_] = match
        %{type: :end, line: line}

      true ->
        %{type: :unknown, line: line}
    end
  end

  def render(token, app_name) do
    case token[:type] do
      :defmodule    -> "defmodule #{app_name}.Repo.Migrations.#{token[:name]} do\n  use Ecto.Migration"
      :up           -> "  def up do"
      :down         -> "  def down do"
      :change       -> "  def change do"
      :create_table -> "    create table(:#{token[:name]}) do"
      :drop_table   -> "    drop table(:#{token[:name]})"
      :add_field    -> "      add :#{token[:name]}, :#{token[:format]}"
      :end          -> token[:line]
      :unknown      -> token[:line]
    end
  end


end