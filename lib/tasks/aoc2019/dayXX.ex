
defmodule Mix.Tasks.AOC2019.DayXX do
  use Mix.Task

  defmodule PuzzleInput do
    defstruct [:lines]
  end

  def solve_p1(input) do
    input |>
    dbg()
    0
  end

  def solve_p2(input) do
    input |>
    dbg()
    0
  end

  def parse_input(input_lines) do
    lines = input_lines
    %PuzzleInput{lines: lines}
  end

  def run(_args) do
    input_directory = Utils.input_directory(__MODULE__)
    Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/example.txt", expected: 0)
    # Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/input.txt", expected: 0)
    # Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/example.txt", expected: 0)
    # Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/input.txt", expected: 0)
  end
end
