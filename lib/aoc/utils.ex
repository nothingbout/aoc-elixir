defmodule Utils do

  def input_directory(module) do
    with [day, year|_] = String.split("#{module}", ".") |> Enum.reverse() do
      "data/#{String.downcase(year)}/#{String.downcase(day)}"
    end
  end

  def read_lines(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
  end

  def expect(value, expected, label) do
    if value != expected do
      IO.puts("Expectation for '#{label}' failed:")
      IO.puts("- got:")
      IO.inspect(value)
      IO.puts("- expected:")
      IO.inspect(expected)
    end
  end

  def run_puzzle(input_parser, solver, label, input_file, options \\ []) do
    input_lines = Utils.read_lines(input_file)
    input = input_parser.(input_lines)

    start_time = System.monotonic_time()

    # {answer, run_count} = {solver.(input), 1}
    {answer, run_count} = 1..Access.get(options, :run_count, 1)
    |> Enum.map(fn _ -> {solver.(input), 1} end)
    |> Enum.reduce(fn {a, token}, {_, counter} -> {a, counter + token} end)

    end_time = System.monotonic_time()

    answer_str = String.pad_leading("#{answer}", 10, " ")
    answer_output = case options[:expected] do
      nil -> "#{answer_str}"
      expected when expected != answer -> "#{answer_str} (WRONG, expected: #{expected})"
      _ -> "#{answer_str} (OK)"
    end

    elapsed_ms = System.convert_time_unit(end_time - start_time, :native, :microsecond) / 1000

    run_count_output = case run_count do
      1 -> ""
      _ -> ", run #{integer_to_delimited(run_count)} times"
    end

    IO.puts("[#{label}]: #{answer_output}, took #{elapsed_ms} ms#{run_count_output} (#{input_file})")
  end

  def integer_to_delimited(num) do
    case {div(num, 1000), rem(num, 1000)} do
      {0, mod} -> Integer.to_string(mod)
      {rem, mod} -> integer_to_delimited(rem) <> "," <> String.pad_leading(Integer.to_string(mod), 3, "0")
    end
  end

  def print_answer(answer, label) do
    IO.puts("#{label}: #{answer}")
  end

  def grid_map_from_rows(lines, filter_value, map_value \\ nil) do
    map_value = if map_value != nil, do: map_value, else: &(&1)
    for {line, y} <- Enum.with_index(lines), {value, x} <- Enum.with_index(line), filter_value.(value) do
      {Vec2.make(x, y), map_value.(value)}
    end |> Map.new()
  end
end
