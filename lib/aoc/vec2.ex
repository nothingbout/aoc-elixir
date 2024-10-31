defmodule Vec2 do
  defstruct [
    :x,
    :y
  ]

  def make(x, y) do
    %__MODULE__{x: x, y: y}
  end

  def zero() do
    make(0, 0)
  end

  def add(a, b) do
    make(a.x + b.x, a.y + b.y)
  end

  def sub(a, b) do
    make(a.x - b.x, a.y - b.y)
  end

  def vabs(a) do
    make(abs(a.x), abs(a.y))
  end

  def vsum(a) do
    a.x + a.y
  end

  def manhattan(a, b) do
    vsum(vabs(sub(b, a)))
  end

  def grid_positions(min, max) do
    for y <- min.y..max.y, x <- min.x..max.x do
      Vec2.make(x, y)
    end
  end
end

defimpl String.Chars, for: Vec2 do
  def to_string(v) do
    "{x: #{v.x}, y: #{v.y}}"
  end
end

defmodule Vec2Extra do
  @offsets8 Vec2.grid_positions(Vec2.make(-1, -1), Vec2.make(1, 1)) |> Enum.filter(fn v -> v.x != 0 || v.y != 0 end)
  def offsets8(), do: @offsets8

  def neighbors8(pos), do: offsets8() |> Enum.map(&(Vec2.add(pos, &1)))
end
