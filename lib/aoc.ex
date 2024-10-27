defmodule AOC do
  def read_lines(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
  end

  def print_answer(answer, label) do
    IO.puts("#{label}: #{answer}")
  end

  def grid_map_from_rows(lines, filter_value, map_value \\ nil) do
    map_value = if map_value != nil, do: map_value, else: &(&1)
    for {line, y} <- Enum.with_index(lines), {value, x} <- Enum.with_index(line), filter_value.(value) do
      {Vec2.make(x, y), map_value.(value)}
    end |> Map.new()
  end
end
