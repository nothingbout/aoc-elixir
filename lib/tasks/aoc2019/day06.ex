
defmodule Mix.Tasks.AOC2019.Day06 do
  use Mix.Task

  defmodule PuzzleInput do
    defstruct [:orbits]
  end

  def count_orbits(orbits_map, parent, depth) do
    depth + case orbits_map[parent] do
      nil -> 0
      children -> children
        |> Enum.map(fn child -> count_orbits(orbits_map, child, depth + 1) end)
        |> Enum.sum()
    end
  end

  def find_parents(inv_orbits_map, child) do
    case inv_orbits_map[child] do
      nil -> []
      parent -> [parent | find_parents(inv_orbits_map, parent)]
    end
  end

  def solve_p1(input) do
    orbits_map = input.orbits |> Enum.reduce(%{}, fn {p, c}, map -> Map.update(map, p, [c], & [c|&1]) end)
    count_orbits(orbits_map, "COM", 0)
  end

  def solve_p2(input) do
    inv_orbits_map = input.orbits |> Enum.map(fn {p, c} -> {c, p} end) |> Map.new()
    you_parents = find_parents(inv_orbits_map, "YOU")
    san_parents = find_parents(inv_orbits_map, "SAN")

    # for {a, i} <- Enum.with_index(you_parents), {b, j} <- Enum.with_index(san_parents) do
    #   if a == b, do: i + j, else: false
    # end
    # |> Enum.find(&(&1 != false))

    # use reduce_while instead of comprehension to get an early return
    Enum.with_index(you_parents) |> Enum.reduce_while(nil, fn {a, i}, _ ->
      dist = Enum.with_index(san_parents) |> Enum.reduce_while(nil, fn {b, j}, _ ->
        if a == b, do: {:halt, i + j}, else: {:cont, nil}
      end)
      if dist != nil, do: {:halt, dist}, else: {:cont, nil}
    end)
  end

  def parse_input(input_lines) do
    orbits = input_lines |> Enum.map(&(String.split(&1, ")") |> List.to_tuple()))
    %PuzzleInput{orbits: orbits}
  end

  def run(_args) do
    input_directory = Utils.input_directory(__MODULE__)
    Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/example_p1.txt", expected: 42)
    Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/input.txt", expected: 301100)
    Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/example_p2.txt", expected: 4)
    Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/input.txt", expected: 547)
  end
end
