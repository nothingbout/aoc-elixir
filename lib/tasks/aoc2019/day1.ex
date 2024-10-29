defmodule Mix.Tasks.AOC2019.Day1 do
  use Mix.Task

  defmodule PuzzleInput do
    defstruct [
      :grid_map
    ]
  end


  def solve_p1(input) do
    0
  end

  def solve_p2(input) do
    0
  end

  def parse_input(input_lines) do
    %PuzzleInput{grid_map: nil}
  end

  def run(_args) do
    Utils.read_lines("data/aoc2019/day1/input.txt") |> parse_input() |> solve_p1() |> Utils.print_answer("Part 1")
    Utils.read_lines("data/aoc2019/day1/input.txt") |> parse_input() |> solve_p2() |> Utils.print_answer("Part 2")
  end
end
