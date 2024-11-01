
defmodule Mix.Tasks.AOC2019.Day04 do
  use Mix.Task

  defmodule PuzzleInput do
    defstruct [:range]
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

  def count_valid_pwds({range_min, range_max}, f_valid_pwd?) do
    range_min..range_max
    |> Enum.map(&Integer.to_string/1)
    |> Enum.reduce(0, fn pwd, acc ->
      if f_valid_pwd?.(pwd) do
        acc + 1
      else
        acc
      end
    end)
  end

  def range_into_equal_chunks({range_min, range_max}, max_chunks) do
    size = range_max - range_min
    per_chunk = div(size - 1, max_chunks) + 1
    num_chunks = div(size - 1, per_chunk) + 1
    0..(num_chunks - 1) |> Enum.map(fn i ->
        {range_min + i * per_chunk, min(range_min + (i + 1) * per_chunk - 1, range_max)}
      end)
  end

  def count_valid_pwds_multithreaded(full_range, f_valid_pwd?, threads) do
    chunk_ranges = full_range |> range_into_equal_chunks(threads)
    parent_pid = self()
    for range <- chunk_ranges do
      spawn_link(fn -> send(parent_pid, count_valid_pwds(range, f_valid_pwd?)) end)
    end
    for _ <- chunk_ranges, reduce: 0 do
      acc -> receive do count -> acc + count end
    end
  end

  def solve(input, f_valid_pwd?, options) do
    case options[:threads] do
      nil -> count_valid_pwds(input.range, f_valid_pwd?)
      threads -> count_valid_pwds_multithreaded(input.range, f_valid_pwd?, threads)
    end
  end

  def solve_p1(input, options \\ nil) do
    solve(input, fn pwd -> has_two_adjacent_same?(pwd) and non_decreasing?(pwd) end, options)
  end

  def solve_p2(input, options \\ nil) do
    solve(input, fn pwd -> has_exactly_two_adjacent_same?(pwd) and non_decreasing?(pwd) end, options)
  end

  def parse_input(input_lines) do
    [range_min, range_max] = String.split(hd(input_lines), "-") |> Enum.map(& String.to_integer(&1))
    %PuzzleInput{range: {range_min, range_max}}
  end

  def run(_args) do
    input_directory = Utils.input_directory(__MODULE__)
    Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/input.txt", expected: 1653)
    Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/input.txt", expected: 1133)
    Utils.run_puzzle(&parse_input/1, & solve_p1(&1, threads: 8), "Part 1", "#{input_directory}/input.txt", expected: 1653)
    Utils.run_puzzle(&parse_input/1, & solve_p2(&1, threads: 8), "Part 2", "#{input_directory}/input.txt", expected: 1133)
  end
end
