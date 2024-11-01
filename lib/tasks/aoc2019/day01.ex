defmodule Mix.Tasks.AOC2019.Day01 do
  use Mix.Task

  defmodule PuzzleInput do
    defstruct [
      :masses
    ]
  end

  def solve_p1(input) do
    input.masses
    |> Enum.map(fn mass -> div(mass, 3) - 2 end)
    |> Enum.sum()
  end

  def rocket_equation(fuel) when fuel <= 0 do
    0
  end

  def rocket_equation(fuel) do
    fuel + rocket_equation(div(fuel, 3) - 2)
  end

  def solve_p2(input) do
    input.masses
    |> Enum.map(fn mass -> rocket_equation(div(mass, 3) - 2) end)
    |> Enum.sum()
  end

  def parse_input(input_lines) do
    masses = input_lines |> Enum.map(&String.to_integer/1)
    %PuzzleInput{masses: masses}
  end

  def run(_args) do
    input_directory = Utils.input_directory(__MODULE__)
    Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/example.txt", expected: 2 + 2 + 654 + 33583)
    Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/input.txt", expected: 3382284)
    Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/example.txt", expected: 2 + 2 + 966 + 50346)
    Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/input.txt", expected: 5070541)
  end
end
