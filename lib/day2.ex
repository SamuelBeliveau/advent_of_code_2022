defmodule AOC.Day2 do
  def solve_a do
    AOC.Utilities.read_lines('inputs/day2.txt')
    |> Enum.map(&parse_line/1)
    |> Enum.map(&calculate_score_a/1)
    |> Enum.sum()
  end

  defp parse_line(line) do
    [_, first, second] = Regex.run(~r/([A-C]+) ([X-Z]+)/, line)
    {first, second}
  end

  # A = X = Rock = 1
  # B = Y = Paper = 2
  # C = Z = Scissors = 3

  defp calculate_score_a({first, second}) do
    own =
      case second do
        "X" -> 1
        "Y" -> 2
        "Z" -> 3
      end

    outcome =
      case {first, second} do
        {"A", "X"} -> 3
        {"B", "Y"} -> 3
        {"C", "Z"} -> 3
        {"A", "Y"} -> 6
        {"B", "Z"} -> 6
        {"C", "X"} -> 6
        {"A", "Z"} -> 0
        {"B", "X"} -> 0
        {"C", "Y"} -> 0
      end

    own + outcome
  end

  def solve_b do
    AOC.Utilities.read_lines('inputs/day2.txt')
    |> Enum.map(&parse_line/1)
    |> Enum.map(&calculate_score_b/1)
    |> Enum.sum()
  end

  defp calculate_score_b({first, second}) do
    case {first, second} do
      {"A", "X"} -> 0 + 3
      {"B", "Y"} -> 3 + 2
      {"C", "Z"} -> 6 + 1
      {"A", "Y"} -> 3 + 1
      {"B", "Z"} -> 6 + 3
      {"C", "X"} -> 0 + 2
      {"A", "Z"} -> 6 + 2
      {"B", "X"} -> 0 + 1
      {"C", "Y"} -> 3 + 3
    end
  end
end
