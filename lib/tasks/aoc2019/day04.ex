
defmodule Mix.Tasks.AOC2019.Day04 do
  use Mix.Task

  defmodule PuzzleInput do
    defstruct [:range_min, :range_max]
  end

  def has_two_adjacent_same?(pwd) do
    String.codepoints(pwd)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> a == b end)
    |> Enum.any?()
  end

  def has_exactly_two_adjacent_same?(pwd) do
    [0 | String.codepoints(pwd)] ++ [0]
    |> Enum.chunk_every(4, 1, :discard)
    |> Enum.map(fn [a, b, c, d] -> a != b and b == c and c != d end)
    |> Enum.any?()
  end

  def non_decreasing?(pwd) do
    String.codepoints(pwd)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> a <= b end)
    |> Enum.all?()
  end

  def solve_p1(input) do
    String.to_integer(input.range_min)..String.to_integer(input.range_max)
    |> Enum.map(&Integer.to_string/1)
    |> Enum.reduce(0, fn pwd, acc ->
      if has_two_adjacent_same?(pwd) and non_decreasing?(pwd) do
        acc + 1
      else
        acc
      end
    end)
  end

  def solve_p2(input) do
    String.to_integer(input.range_min)..String.to_integer(input.range_max)
    |> Enum.map(&Integer.to_string/1)
    |> Enum.reduce(0, fn pwd, acc ->
        if has_exactly_two_adjacent_same?(pwd) and non_decreasing?(pwd) do
          acc + 1
        else
          acc
      end
    end)
  end

  def parse_input(input_lines) do
    [range_min, range_max] = String.split(hd(input_lines), "-")
    %PuzzleInput{range_min: range_min, range_max: range_max}
  end

  def run(_args) do
    input_directory = Utils.input_directory(__MODULE__)
    # Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/example.txt", expected: 0)
    Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/input.txt", expected: 1653)
    # Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/example.txt", expected: 0)
    Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/input.txt", expected: 1133)
  end
end
