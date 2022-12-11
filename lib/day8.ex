defmodule AOC.Day8 do
  def solve_a do
    grid =
      AOC.Utilities.read_lines('inputs/day8.txt')
      |> parse_lines()

    grid
    |> Enum.map(fn {coords, _} -> is_visible(coords, grid) end)
    |> Enum.count(& &1)
  end

  defp parse_lines(lines) do
    lines
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, row_index}, acc ->
      row
      |> Enum.map(&(&1 |> Integer.parse() |> elem(0)))
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {value, col_index}, acc2 ->
        Map.put(acc2, {col_index, row_index}, value)
      end)
      |> Map.merge(acc)
    end)
  end

  defp is_visible(coords, grid) do
    visible =
      Enum.any?([
        reaches_direction(coords, grid, nil, :left),
        reaches_direction(coords, grid, nil, :top),
        reaches_direction(coords, grid, nil, :right),
        reaches_direction(coords, grid, nil, :bottom)
      ])

    visible
  end

  defp reaches_direction(coords, grid, initial_value, direction) do
    curr_value = Map.get(grid, coords)

    case curr_value do
      nil ->
        true

      value when initial_value == nil ->
        reaches_direction(move(coords, direction), grid, value, direction)

      value when initial_value > value ->
        reaches_direction(move(coords, direction), grid, initial_value, direction)

      _ ->
        false
    end
  end

  defp move({x, y}, direction) do
    case direction do
      :left -> {x - 1, y}
      :right -> {x + 1, y}
      :top -> {x, y - 1}
      :bottom -> {x, y + 1}
    end
  end

  defp seeing_direction(coords, grid, initial_value, direction, count) do
    curr_value = Map.get(grid, coords)

    case curr_value do
      nil ->
        count

      value when initial_value == nil ->
        seeing_direction(move(coords, direction), grid, value, direction, 0)

      value when initial_value > value ->
        seeing_direction(move(coords, direction), grid, initial_value, direction, count + 1)

      _ ->
        count + 1
    end
  end

  defp calculate_score(coords, grid) do
    Enum.product([
      seeing_direction(coords, grid, nil, :left, 0),
      seeing_direction(coords, grid, nil, :right, 0),
      seeing_direction(coords, grid, nil, :top, 0),
      seeing_direction(coords, grid, nil, :bottom, 0)
    ])
  end

  def solve_b do
    grid =
      AOC.Utilities.read_lines('inputs/day8.txt')
      |> parse_lines()

    grid
    |> Enum.map(fn {coords, _} -> calculate_score(coords, grid) end)
    |> Enum.max()
  end
end
