defmodule AOC.Day3 do
  def solve_a do
    AOC.Utilities.read_lines('inputs/day3.txt')
    |> Enum.map(&parse_line/1)
    |> Enum.map(&find_common_a/1)
    |> Enum.map(&calculate_priority/1)
    |> Enum.sum()
  end

  defp parse_line(line) do
    mid_point = floor(String.length(line) / 2)

    String.split_at(line, mid_point) |> Tuple.to_list()
  end

  defp find_common_a(compartments) do
    [first, second] =
      compartments
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&MapSet.new/1)

    MapSet.intersection(first, second) |> MapSet.to_list() |> Enum.at(0)
  end

  def calculate_priority(item) do
    {<<lowercase_a::utf8>>, <<uppercase_a::utf8>>, <<uppercase_z::utf8>>} = {"a", "A", "Z"}

    <<item_pos::utf8>> = item

    if item_pos <= uppercase_z do
      item_pos - uppercase_a + 27
    else
      item_pos - lowercase_a + 1
    end
  end

  def solve_b do
    AOC.Utilities.read_lines('inputs/day3.txt')
    |> Enum.chunk_every(3)
    |> Enum.map(&find_common_b/1)
    |> Enum.map(&calculate_priority/1)
    |> Enum.sum()
  end

  defp find_common_b(sacks) do
    [first, second, third] =
      sacks
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&MapSet.new/1)

    MapSet.intersection(first, second)
    |> MapSet.intersection(third)
    |> MapSet.to_list()
    |> Enum.at(0)
  end
end
