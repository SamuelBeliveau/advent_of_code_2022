defmodule AOC.Day1 do
  def solve_a do
    lines = AOC.Utilities.read_lines('inputs/day1.txt', false)

    {_, max} =
      lines
      |> Enum.reduce({0, 0}, fn line, {current, max} ->
        case Integer.parse(line) do
          {number, _} -> {current + number, max}
          _ -> {0, max(current, max)}
        end
      end)

    max
  end

  def solve_b do
    lines = AOC.Utilities.read_lines('inputs/day1.txt', false)

    {_, list} =
      lines
      |> Enum.reduce({0, []}, fn line, {current, list} ->
        case Integer.parse(line) do
          {number, _} -> {current + number, list}
          _ -> {0, [current | list]}
        end
      end)

    list
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
