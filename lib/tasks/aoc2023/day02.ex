

defmodule Mix.Tasks.AOC2023.Day02 do
  use Mix.Task

  defmodule CubeSet do
    defstruct [
      :color_count_map
    ]
  end

  defmodule Game do
    defstruct [
      :game_id,
      :revealed_cube_sets
    ]
  end

  defmodule PuzzleInput do
    defstruct [
      :games
    ]
  end

  def is_possible_set(cubes, bag_cubes) do
    invalid_cubes = cubes.color_count_map |> Stream.filter(fn {color, count} ->
      Map.get(bag_cubes.color_count_map, color, 0) < count
    end)
    invalid_cubes |> Enum.take(1) |> length() == 0
  end

  def is_possible_game(game, bag_cubes) do
    invalid_sets = game.revealed_cube_sets |> Stream.filter(fn cubes ->
        not is_possible_set(cubes, bag_cubes)
    end)
    invalid_sets |> Enum.take(1) |> length() == 0
  end

  def combine_maps_max(map1, map2) do
    map2 |> Enum.reduce(map1, fn {key, value}, acc_map ->
      Map.put(acc_map, key, max(value, Map.get(acc_map, key, 0)))
    end)
  end

  def game_min_cubes(game) do
    min_cubes = game.revealed_cube_sets
    |> Enum.map(&(&1.color_count_map))
    |> Enum.reduce(&combine_maps_max/2)
    %CubeSet{color_count_map: min_cubes}
  end

  def cubes_power(cube_set) do
    cube_set.color_count_map
    |> Enum.reduce(1, fn {_, count}, acc -> count * acc end)
  end

  def solve_p1(input) do
    # IO.inspect(input)
    bag_cubes = %CubeSet{color_count_map: %{"red" => 12, "green" => 13, "blue" => 14}}
    valid_games = input.games |> Enum.filter(&(is_possible_game(&1, bag_cubes)))
    total = valid_games |> Stream.map(&(&1.game_id)) |> Enum.sum
    IO.puts("Part1: #{total}")
  end

  def solve_p2(input) do
    # IO.inspect(game_min_cubes(List.first(input.games)))
    powers = input.games
    |> Enum.map(&game_min_cubes/1)
    |> Enum.map(&cubes_power/1)
    total = Enum.sum(powers)
    IO.puts("Part2: #{total}")
  end

  def parse_input(input_lines) do
    games = Stream.iterate(1, &(&1 + 1)) |> Stream.zip(input_lines) |> Enum.map(fn {game_id, line} ->
      # Game 14: 12 blue, 3 red, 4 green; 3 green, 1 red; 6 green, 16 blue
      [_ | [sets_str | _]] = line |> String.split(": ")
      sets = sets_str |> String.split("; ") |> Enum.map(fn set_str ->
        color_counts = set_str |> String.split(", ") |> Enum.map(fn cube_count_str ->
          [count_str, color_str] = cube_count_str |> String.split(" ")
          {color_str, String.to_integer(count_str)}
        end)
        %CubeSet{color_count_map: Map.new(color_counts)}
      end)
      %Game{game_id: game_id, revealed_cube_sets: sets}
    end)
    %PuzzleInput{games: games}
  end

  def run(_args) do
    Utils.read_lines("data/aoc2023/day02/input.txt") |> parse_input() |> solve_p1()
    Utils.read_lines("data/aoc2023/day02/input.txt") |> parse_input() |> solve_p2()
  end
end
