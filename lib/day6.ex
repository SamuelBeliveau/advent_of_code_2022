defmodule AOC.Day6 do
  def solve_a do
    [line | _] = AOC.Utilities.read_lines('inputs/day6.txt')

    sequence_length = 4

    index =
      line
      |> String.graphemes()
      |> Enum.chunk_every(sequence_length, 1, :discard)
      |> Enum.find_index(fn window ->
        length(window) == window |> Enum.uniq() |> length()
      end)

    index + sequence_length
  end

  def solve_b do
    [line | _] = AOC.Utilities.read_lines('inputs/day6.txt')

    sequence_length = 14

    index =
      line
      |> String.graphemes()
      |> Enum.chunk_every(sequence_length, 1, :discard)
      |> Enum.find_index(fn window ->
        length(window) == window |> Enum.uniq() |> length()
      end)

    index + sequence_length
  end
end
