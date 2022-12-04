defmodule AOC.Day4 do
  def solve_a do
    AOC.Utilities.read_lines('inputs/day4.txt')
    |> Enum.map(&parse_line/1)
    |> Enum.filter(&any_contains?/1)
    |> Enum.count()
  end

  defp parse_line(line) do
    [_ | bounds] = Regex.run(~r/(\d+)-(\d+),(\d+)-(\d+)/, line)
    [min_a, max_a, min_b, max_b] = bounds |> Enum.map(&Integer.parse/1) |> Enum.map(&elem(&1, 0))
    {min_a, max_a, min_b, max_b}
  end

  defp any_contains?({min_a, max_a, min_b, max_b}) do
    (min_a >= min_b && max_a <= max_b) || (min_b >= min_a && max_b <= max_a)
  end

  def solve_b do
    AOC.Utilities.read_lines('inputs/day4.txt')
    |> Enum.map(&parse_line/1)
    |> Enum.filter(&overlaps?/1)
    |> Enum.count()
  end

  defp overlaps?({min_a, max_a, min_b, max_b}) do
    (min_a >= min_b && min_a <= max_b) || (max_a >= min_b && max_a <= max_b) ||
      (min_b >= min_a && min_b <= max_a) || (max_b >= min_a && max_b <= max_a)
  end
end
