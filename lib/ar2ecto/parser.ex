defmodule Ar2ecto.Parser do
  alias Ar2ecto.Line, as: L
  alias Ar2ecto.Writer, as: W

  def parse(app_name, file, output_dir) do
    if File.dir?(file) do
      _parse(file, app_name, output_dir, :dir)
    else
      _parse(file, app_name, output_dir, :file)
    end
  end

  defp _parse(file, app_name, output_dir, :file) do
    file
    |> File.read!
    |> String.split("\n")
    |> process(app_name, [])
    |> W.write(file, output_dir)
  end

  defp _parse(dir, app_name, output_dir, :dir) do
    dir
    |> File.ls!
    |> Enum.map(&(Path.join(dir,&1)))
    |> Enum.map(&(_parse(&1, app_name, output_dir, :file)))
  end

  defp process(line, app_name) when is_binary(line), do: line |> L.tokenize |> L.render(app_name)
  defp process([], _app_name, answer), do: answer
  defp process([line|tail], app_name, answer) do
    answer ++ [ process(line, app_name) ] ++ process(tail, app_name, [])
  end

end