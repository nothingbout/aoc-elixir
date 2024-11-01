defmodule Mix.Tasks.AOC2023.Day01 do
  use Mix.Task

  def is_digit?(codepoint) do
    case Integer.parse(codepoint) do
      {number, remainder} when number >= 1 and number <= 9 and byte_size(remainder) == 0 -> true
      _ -> false
    end
  end

  def prefix_to_digit(str) do
    case str do
      "one" <> _ -> "1"
      "two" <> _  -> "2"
      "three" <> _  -> "3"
      "four" <> _  -> "4"
      "five" <> _  -> "5"
      "six" <> _  -> "6"
      "seven" <> _  -> "7"
      "eight" <> _  -> "8"
      "nine" <> _  -> "9"
      _ -> if is_digit?(String.first(str)), do: String.first(str), else: nil
    end
  end

  def suffix_to_digit(str) do
    case str do
      "eno" <> _ -> "1"
      "owt" <> _  -> "2"
      "eerht" <> _  -> "3"
      "ruof" <> _  -> "4"
      "evif" <> _  -> "5"
      "xis" <> _  -> "6"
      "neves" <> _  -> "7"
      "thgie" <> _  -> "8"
      "enin" <> _  -> "9"
      _ -> if is_digit?(String.first(str)), do: String.first(str), else: nil
    end
  end

  def first_occurrence(str, fn_value_or_nil) do
    0..String.length(str)
    |> Stream.map(&(String.slice(str, &1..-1//1)))
    |> Stream.map(fn_value_or_nil)
    |> Enum.find(&(&1))
  end

  def calibration_value_with_digits(line) do
    digits = String.codepoints(line) |> Enum.filter(&is_digit?/1)
    String.to_integer(List.first(digits) <> List.last(digits))
  end

  def calibration_value_with_names(line) do
    first_digit = first_occurrence(line, &prefix_to_digit/1)
    last_digit = first_occurrence(String.reverse(line), &suffix_to_digit/1)
    String.to_integer(first_digit <> last_digit)
  end

  def solve_p1(input_lines) do
    total = input_lines |> Enum.map(&calibration_value_with_digits/1) |> Enum.sum()
    IO.puts("Part1: #{total}")
  end

  def solve_p2(input_lines) do
    total = input_lines |> Enum.map(&calibration_value_with_names/1) |> Enum.sum()
    IO.puts("Part2: #{total}")
  end

  def run(_args) do
    Utils.read_lines("data/aoc2023/day01/input.txt") |> solve_p1()
    Utils.read_lines("data/aoc2023/day01/input.txt") |> solve_p2()
  end
end
