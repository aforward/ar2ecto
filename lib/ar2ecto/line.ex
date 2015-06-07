defmodule Ar2ecto.Line do

  def tokenize(nil), do: %{type: :unknown, line: nil}
  def tokenize(line) do
    cond do

      match = Regex.run(~r{for\s*([^\s]*)\s*in}, line) ->
        %{type: :ignore_block}

      match = Regex.run(~r{.*class\s*([^\s]*)\s*<\s*ActiveRecord::Migration.*}, line) ->
        [_, name] = match
        %{type: :defmodule, name: name}

      match = Regex.run(~r{def\s*self\.(up|down|change)}, line) ->
        [_, direction] = match
        %{type: String.to_atom(direction)}

      match = Regex.run(~r{(add_index|remove_index)\s*:([^\s]*),\s*:([^\s]*)}, line) ->
        [_, operation, table, field] = match
        %{type: String.to_atom(operation), table: String.to_atom(table), fields: [String.to_atom(field)]}

      match = Regex.run(~r{(create_table|drop_table)\s*\(?\s*\"([^\"]*)\"}, line) ->
        [_, operation, name] = match
        tokenize_create_table(operation, name, line)

      match = Regex.run(~r{(create_table|drop_table)\s*\(?\s*:([^\s,]*)}, line) ->
        [_, operation, name] = match
        tokenize_create_table(operation, name, line)

      match = Regex.run(~r{rename_column\s*:([^\s]*)\s*,\s*:([^\s,]*)\s*,\s*:([^\s,]*)\s*}, line) ->
        [_, table, old_name, new_name] = match
        %{type: :rename_column,
          table: String.to_atom(table),
          old_name: String.to_atom(old_name),
          new_name: String.to_atom(new_name)}

      match = Regex.run(~r{add_column\s*:([^\s]*)\s*,\s*:([^\s,]*)\s*,\s*:([^\s,]*)\s*}, line) ->
        [_, table, name, format] = match
        line
        |> field_opts
        |> Dict.merge(%{type: :add_column,
                        table: String.to_atom(table),
                        format: String.to_atom(format),
                        name: String.to_atom(name)})

      match = Regex.run(~r{remove_column\s*:([^\s]*)\s*,\s*:([^\s,]*)}, line) ->
        [_, table, name] = match
        %{type: :remove_column, table: String.to_atom(table), name: String.to_atom(name)}

      match = Regex.run(~r{[^\s]*\.([^\s]*)\s*:([^\s,]*)}, line) ->
        [_, format, name] = match
        line
        |> field_opts
        |> Dict.merge(%{type: :add_field,
                        name: String.to_atom(name),
                        format: String.to_atom(format)})

      match = Regex.run(~r{\s*end\s*}, line) ->
        [_] = match
        %{type: :end, line: line}

      match = Regex.run(~r{\s*timestamps\s*}, line) ->
        [_] = match
        %{type: :timestamps}

      true ->
        %{type: :unknown, line: line}
    end
  end

  def render(token, app_name) do
    case token[:type] do
      :defmodule       -> "defmodule #{app_name}.Repo.Migrations.#{token[:name]} do\n  use Ecto.Migration"
      :up              -> "  def up do"
      :down            -> "  def down do"
      :change          -> "  def change do"
      :create_table    -> "    create table(:#{token[:name]}#{render_create_table_opts(token)}) do"
      :drop_table      -> "    drop table(:#{token[:name]})"
      :add_field       -> "      add :#{token[:name]}, :#{token[:format]}#{render_add_coumn_opts(token)}"
      :timestamps      -> "      timestamps"
      :add_index       -> "    #{render_index(:create, token)}"
      :remove_index    -> "    #{render_index(:drop, token)}"
      :end             -> token[:line]
      :unknown         -> token[:line]
      :remove_column   -> "    alter table(:#{token[:table]}) do\n      remove :#{token[:name]}\n    end"
      :add_column      -> "    alter table(:#{token[:table]}) do\n      add :#{token[:name]}, :#{token[:format]}#{render_add_coumn_opts(token)}\n    end"
      :rename_column   -> "    execute \"ALTER TABLE #{token[:table]} RENAME COLUMN #{token[:old_name]} TO #{token[:new_name]}\""
    end
  end

  defp tokenize_create_table("create_table", name, line) do
    primary_key = cond do
      Regex.run(~r{:id\s*=>\s*false}, line) -> false
      Regex.run(~r{id:\s*false}, line) -> false
      true -> true
    end
    %{type: :create_table, name: String.to_atom(name), primary_key: primary_key}
  end
  defp tokenize_create_table(operation, name, line) do
    %{type: String.to_atom(operation), name: String.to_atom(name)}
  end

  defp field_opts(line) do
    default = cond do
      Regex.run(~r{:default\s*=>\s*nil}, line) -> :null
      true -> nil
    end

    size = cond do
      submatch = Regex.run(~r{:limit\s*=>\s*([^\s]*)}, line) ->
        [_, size] = submatch
        size
      true ->
        nil
    end
    %{default: default, size: size}
  end

  defp render_index(create_or_drop, token) do
    "#{create_or_drop} index(:#{token[:table]}, [:#{token[:fields] |> Enum.join(",:")}])"
  end

  defp render_add_coumn_opts(token) do
    default_opt = case token[:default] do
      :null -> ", default: nil"
      _     -> ""
    end
    size_opt = case token[:size] do
      nil  -> ""
      _     -> ", size: #{token[:size]}"
    end
    "#{default_opt}#{size_opt}"
  end

  defp render_create_table_opts(token) do
    if token[:primary_key] == false do
      ", primary_key: false"
    else
      ""
    end
  end


end