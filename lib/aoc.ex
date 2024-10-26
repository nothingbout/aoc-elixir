defmodule AOC do
  def read_lines(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
  end
end
