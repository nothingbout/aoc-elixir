
defmodule Mix.Tasks.AOC2019.Day05 do
  use Mix.Task

  defmodule PuzzleInput do
    defstruct [:ints]
  end

  def arg_value(mem, op_pos, param_idx, modes) do
    mode = modes |> div(Integer.pow(10, param_idx)) |> rem(10)
    case mode do
      0 -> mem[mem[op_pos + 1 + param_idx]]
      1 -> mem[op_pos + 1 + param_idx]
    end
  end

  # outputs are reversed in the list
  def simulate(mem, pos, inputs, outputs) do
    {opcode, modes} = with m = mem[pos], do: {rem(m, 100), div(m, 100)}
    case opcode do
      1 -> # add (a, b) -> c
        result = arg_value(mem, pos, 0, modes) + arg_value(mem, pos, 1, modes)
        new_mem = Map.put(mem, mem[pos + 3], result)
        simulate(new_mem, pos + 4, inputs, outputs)
      2 -> # multiply (a, b) -> c
        result = arg_value(mem, pos, 0, modes) * arg_value(mem, pos, 1, modes)
        new_mem = Map.put(mem, mem[pos + 3], result)
        simulate(new_mem, pos + 4, inputs, outputs)
      3 -> # input (a)
        new_mem = Map.put(mem, mem[pos + 1], hd(inputs))
        simulate(new_mem, pos + 2, tl(inputs), outputs)
      4 -> # output () -> a
        result = arg_value(mem, pos, 0, modes)
        simulate(mem, pos + 2, inputs, [result | outputs])
      5 -> # jump-if-true (a, b)
        new_pos = if arg_value(mem, pos, 0, modes) != 0, do: arg_value(mem, pos, 1, modes), else: pos + 3
        simulate(mem, new_pos, inputs, outputs)
      6 -> # jump-if-false (a, b)
        new_pos = if arg_value(mem, pos, 0, modes) == 0, do: arg_value(mem, pos, 1, modes), else: pos + 3
        simulate(mem, new_pos, inputs, outputs)
      7 -> # less than (a, b) -> c
        result = if arg_value(mem, pos, 0, modes) < arg_value(mem, pos, 1, modes), do: 1, else: 0
        new_mem = Map.put(mem, mem[pos + 3], result)
        simulate(new_mem, pos + 4, inputs, outputs)
      8 -> # equals (a, b) -> c
        result = if arg_value(mem, pos, 0, modes) == arg_value(mem, pos, 1, modes), do: 1, else: 0
        new_mem = Map.put(mem, mem[pos + 3], result)
        simulate(new_mem, pos + 4, inputs, outputs)
      99 -> # halt
        outputs
    end
  end

  def solve_p1(input) do
    mem = input.ints |> Enum.with_index() |> Enum.map(fn {x, i} -> {i, x} end) |> Map.new()
    outputs = simulate(mem, 0, [1], [])
    hd(outputs)
  end

  def solve_p2(input) do
    mem = input.ints |> Enum.with_index() |> Enum.map(fn {x, i} -> {i, x} end) |> Map.new()
    outputs = simulate(mem, 0, [5], [])
    hd(outputs)
  end

  def parse_input(input_lines) do
    ints = input_lines |> List.first() |> String.split(",") |> Enum.map(&String.to_integer/1)
    %PuzzleInput{ints: ints}
  end

  def run(_args) do
    input_directory = Utils.input_directory(__MODULE__)
    # Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/example.txt", expected: 0)
    Utils.run_puzzle(&parse_input/1, &solve_p1/1, "Part 1", "#{input_directory}/input.txt", expected: 5182797)
    # Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/example.txt", expected: 0)
    Utils.run_puzzle(&parse_input/1, &solve_p2/1, "Part 2", "#{input_directory}/input.txt", expected: 12077198)
  end
end
