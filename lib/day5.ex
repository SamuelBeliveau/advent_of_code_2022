defmodule AOC.Day5 do
  @stacks %{
    1 => ['J', 'Z', 'G', 'V', 'T', 'D', 'B', 'N'],
    2 => ['F', 'P', 'W', 'D', 'M', 'R', 'S'],
    3 => ['Z', 'S', 'R', 'C', 'V'],
    4 => ['G', 'H', 'P', 'Z', 'J', 'T', 'R'],
    5 => ['F', 'Q', 'Z', 'D', 'N', 'J', 'C', 'T'],
    6 => ['M', 'F', 'S', 'G', 'W', 'P', 'V', 'N'],
    7 => ['Q', 'P', 'B', 'V', 'C', 'G'],
    8 => ['N', 'P', 'B', 'Z'],
    9 => ['J', 'P', 'W']
  }

  def solve_a do
    AOC.Utilities.read_lines('inputs/day5.txt')
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(@stacks, fn instruction, acc ->
      move_a(instruction, acc)
    end)
    |> extract_message()
  end

  defp parse_line(line) do
    [_ | numbers] = Regex.run(~r/move (\d+) from (\d+) to (\d+)/, line)
    [amount, src, dest] = numbers |> Enum.map(&Integer.parse/1) |> Enum.map(&elem(&1, 0))
    {amount, src, dest}
  end

  defp move_a({amount, src, dest}, stacks) do
    1..amount
    |> Enum.reduce(stacks, fn _, acc ->
      {removed, acc} =
        Map.get_and_update(acc, src, fn stack ->
          [top | rest] = stack
          {top, rest}
        end)

      Map.update(acc, dest, [], fn stack ->
        [removed | stack]
      end)
    end)
  end

  defp extract_message(stacks) do
    stacks
    |> Enum.map(fn {_, stack} ->
      [top | _] = stack
      top
    end)
    |> List.to_string()
  end

  def solve_b do
    AOC.Utilities.read_lines('inputs/day5.txt')
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(@stacks, fn instruction, acc ->
      move_b(instruction, acc)
    end)
    |> extract_message()
  end

  defp move_b({amount, src, dest}, stacks) do
    {stacks, buffer} =
      1..amount
      |> Enum.reduce({stacks, []}, fn _, {stacks, buffer} ->
        {removed, stacks} =
          Map.get_and_update(stacks, src, fn stack ->
            [top | rest] = stack
            {top, rest}
          end)

        {stacks, [removed | buffer]}
      end)

    buffer
    |> Enum.reduce(stacks, fn removed, acc ->
      Map.update(acc, dest, [], fn stack ->
        [removed | stack]
      end)
    end)
  end
end
