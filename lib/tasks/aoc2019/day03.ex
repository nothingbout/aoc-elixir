
defmodule Mix.Tasks.AOC2019.Day03 do
  use Mix.Task

  defmodule PuzzleInput do
    defstruct [:wires]
  end

  def line_intersection(a1, a2, b1, b2) do
    cond do
      a1.x == a2.x and b1.x == b2.x ->
        nil
      a1.y == a2.y and b1.y == b2.y ->
        nil
      a1.x == a2.x ->
        # swap arguments such that a is horizontal, b is vertical
        line_intersection(b1, b2, a1, a2)
      true ->
        p = Vec2.make(b1.x, a1.y)
        cond do
          p.y < min(b1.y, b2.y) or p.y > max(b1.y, b2.y) ->
            nil
            p.x < min(a1.x, a2.x) or p.x > max(a1.x, a2.x) ->
            nil
          true ->
            p
        end
    end
  end

  def wire_segment_vector({dir, dist}) do
    case dir do
      "R" -> Vec2.make(dist, 0)
      "U" -> Vec2.make(0, dist)
      "L" -> Vec2.make(-dist, 0)
      "D" -> Vec2.make(0, -dist)
    end
  end

  def wire_points(wire) do
    {points, _} = wire |> Enum.map_reduce(Vec2.make(0, 0), fn segment, pos ->
      next_pos = Vec2.add(pos, wire_segment_vector(segment))
      {next_pos, next_pos}
    end)
    [Vec2.make(0, 0) | points]
  end

  def wire_intersections(wire1, wire2) do
    a_points = wire_points(wire1)
    b_points = wire_points(wire2)
    for [a1, a2] <- Enum.chunk_every(a_points, 2, 1, :discard), [b1, b2] <- Enum.chunk_every(b_points, 2, 1, :discard) do
      line_intersection(a1, a2, b1, b2)
    end
    |> Enum.filter(&(&1 != nil && &1 != Vec2.zero()))
  end

  def solve_p1(input) do
    intersections = with [wire1, wire2|_] = input.wires, do: wire_intersections(wire1, wire2)
    intersections |> Enum.map(fn p -> abs(p.x) + abs(p.y) end) |> Enum.min()
  end

  def wire_intersection_distances(wire1, wire2) do
    a_points = wire_points(wire1)
    b_points = wire_points(wire2)

    {intersections, _} = Enum.chunk_every(a_points, 2, 1, :discard) |> Enum.flat_map_reduce(0, fn [a1, a2], a_dist ->
      {intersections, _} = Enum.chunk_every(b_points, 2, 1, :discard) |> Enum.map_reduce(0, fn [b1, b2], b_dist ->
        d = case line_intersection(a1, a2, b1, b2) do
          nil ->
            nil
          p ->
            # IO.puts("#{a_dist}, (#{a1} -> #{a2}), #{b_dist}, (#{b1} -> #{b2}) => #{p}")
            a_dist + Vec2.manhattan(a1, p) + b_dist + Vec2.manhattan(b1, p)
        end
        {d, b_dist + Vec2.manhattan(b1, b2)}
      end)
      {intersections, a_dist + Vec2.manhattan(a1, a2)}
    end)

    intersections
    |> Enum.filter(&(&1 != nil && &1 != 0))
  end

  def solve_p2(input) do
    intersections = with [wire1, wire2|_] = input.wires, do: wire_intersection_distances(wire1, wire2)
    intersections |> Enum.min()
  end

  def parse_input(input_lines) do
    wires = for line <- input_lines do
      line |> String.split(",")
      |> Enum.map(fn
          <<dir :: binary-size(1)>> <> dist -> {dir, String.to_integer(dist)}
        end)
    end
    %PuzzleInput{wires: wires}
  end

  def run(_args) do
    input_directory = Utils.input_directory(__MODULE__)
    Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/example.txt", expected: 6)
    Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/input.txt", expected: 721)
    Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/example.txt", expected: 30)
    Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/input.txt", expected: 7388)
  end
end
