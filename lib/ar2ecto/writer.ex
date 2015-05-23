defmodule Ar2ecto.Writer do

  def destination(input_filename, output_dir) do
    input_filename
    |> Path.basename
    |> rename_ext("exs")
    |> join_dest(output_dir)
  end

  def write(parsed, input_filename, output_dir) do
    parsed
    |>  Enum.join("\n")
    |> save(input_filename, output_dir)
  end

  defp rename_ext(old_name, new_ext), do: Regex.replace(~r{\..*$}, old_name, ".#{new_ext}")
  defp join_dest(basename, output_dir), do: Path.join(output_dir, basename)

  defp save(content, input_filename, output_dir) do
    output_filename = destination(input_filename, output_dir)
    File.mkdir_p(output_dir)
    {:ok, file} = File.open output_filename, [:write]
    IO.binwrite file, content
    File.close file
    output_filename
  end

end