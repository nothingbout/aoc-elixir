defmodule Mix.Tasks.AOC2019.Day02 do
  use Mix.Task

  defmodule PuzzleInput do
    defstruct [
      :ints
    ]
  end

  def simulate_until_halt(mem, pos) do
    case mem[pos] do
      1 -> simulate_until_halt(Map.put(mem, mem[pos + 3], mem[mem[pos + 1]] + mem[mem[pos + 2]]), pos + 4)
      2 -> simulate_until_halt(Map.put(mem, mem[pos + 3], mem[mem[pos + 1]] * mem[mem[pos + 2]]), pos + 4)
      99 -> mem
    end
  end

  def solve_p1(input) do
    mem = input.ints |> Enum.with_index() |> Enum.map(fn {x, i} -> {i, x} end) |> Map.new()
    mem = Map.put(mem, 1, 12)
    mem = Map.put(mem, 2, 2)
    halted_mem = simulate_until_halt(mem, 0)
    halted_mem[0]
  end

  def solve_p2(input) do
    mem = input.ints |> Enum.with_index() |> Enum.map(fn {x, i} -> {i, x} end) |> Map.new()
    for noun <- 0..99, verb <- 0..99 do
      halted_mem = mem |> Map.put(1, noun) |> Map.put(2, verb) |> simulate_until_halt(0)
      case halted_mem[0] do
        19690720 -> 100 * noun + verb
        _ -> false
      end
    end
    |> Stream.filter(&(!!&1))
    |> Enum.at(0)
  end

  def parse_input(input_lines) do
    ints = input_lines |> List.first() |> String.split(",") |> Enum.map(&String.to_integer/1)
    %PuzzleInput{ints: ints}
  end

  def run(_args) do
    input_directory = Utils.input_directory(__MODULE__)
    # Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/example.txt")
    Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/input.txt", expected: 4138658)
    # Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/example.txt", expected: 0)
    Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/input.txt", expected: 7264)
  end
end
