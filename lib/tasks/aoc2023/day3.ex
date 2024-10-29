defmodule Mix.Tasks.AOC2023.Day3 do
  use Mix.Task

  defmodule PuzzleInput do
    defstruct [
      :grid_map
    ]
  end

  def digit?(codepoint) do
    codepoint != nil and byte_size(codepoint) == 1 and Integer.parse(codepoint) != :error
  end

  def symbol?(codepoint) do
    codepoint != nil and not digit?(codepoint)
  end

  def part_digits_tail_at(grid_map, pos) do
    case grid_map[pos] do
      nil -> []
      value -> case digit?(value) do
        false -> []
        true -> [{pos, value} | part_digits_tail_at(grid_map, Vec2.make(pos.x + 1, pos.y))]
      end
    end
  end

  def part_digits_starting_at(grid_map, pos) do
    if digit?(grid_map[pos]) and not digit?(grid_map[Vec2.make(pos.x - 1, pos.y)]) do
      part_digits_tail_at(grid_map, pos)
    else
      nil
    end
  end

  defmodule Part do
    defstruct [
      :id,
      :number,
      :start_pos,
      :end_pos,
    ]
  end

  def make_part_from_digits(id, part_digits) do
    %Part{
      id: id,
      number: Enum.map(part_digits, fn {_, digit} -> digit end) |> List.to_string() |> String.to_integer(),
      start_pos: elem(List.first(part_digits), 0),
      end_pos: elem(List.last(part_digits), 0),
    }
  end

  def find_parts(grid_map) do
     all_parts_digits = Map.keys(grid_map)
     |> Enum.map(&(part_digits_starting_at(grid_map, &1)))
     |> Enum.reject(&is_nil/1)

     for {part_digits, part_id} <- Enum.with_index(all_parts_digits) do
       make_part_from_digits(part_id, part_digits)
     end
  end

  def make_parts_map(parts) do
    for part <- parts, pos <- Vec2.grid_positions(part.start_pos, part.end_pos) do
      {pos, part}
    end |> Map.new()
  end

  def parts_next_to_position(parts_map, pos) do
    for npos <- Vec2Extra.neighbors8(pos), part = parts_map[npos], part != nil, uniq: true do
      part
    end
  end

  def solve_p1(input) do
    parts = find_parts(input.grid_map)
    parts_map = make_parts_map(parts)

    input.grid_map
    |> Enum.filter(fn {_, value} -> symbol?(value) end)
    |> Enum.map(fn {pos, _} -> parts_next_to_position(parts_map, pos) end)
    |> List.flatten() |> Enum.uniq()
    |> Enum.map(fn part -> part.number end)
    |> Enum.sum()
  end

  def solve_p2(input) do
    parts = find_parts(input.grid_map)
    parts_map = make_parts_map(parts)

    input.grid_map
    |> Enum.filter(fn {_, value} -> value == "*" end)
    |> Enum.map(fn {pos, _} -> parts_next_to_position(parts_map, pos) end)
    |> Enum.map(fn
      [p1, p2] -> p1.number * p2.number
      _ -> 0
    end)
    |> Enum.sum()
  end

  def parse_input(input_lines) do
    grid_map = input_lines
    |> Enum.map(&String.codepoints/1)
    |> Utils.grid_map_from_rows(&(&1 != "."))
    %PuzzleInput{grid_map: grid_map}
  end

  def run(_args) do
    Utils.read_lines("data/aoc2023/day3/input.txt") |> parse_input() |> solve_p1() |> Utils.print_answer("Part 1")
    Utils.read_lines("data/aoc2023/day3/input.txt") |> parse_input() |> solve_p2() |> Utils.print_answer("Part 2")
  end
end
