defmodule AOC.Day9 do
  def solve_a do
    {_, _, _, tail_moves} =
      AOC.Utilities.read_lines('inputs/day9.txt')
      |> Enum.map(&parse_line/1)
      |> Enum.reduce({{0, 0}, %{}, {0, 0}, %{}}, fn action, acc ->
        run_action(action, acc)
      end)

    tail_moves
    |> Map.keys()
    |> Enum.count()
  end

  defp parse_line(line) do
    [_, direction, amount] = Regex.run(~r/([A-Z]+)\s(\d+)/, line)
    {direction, amount |> Integer.parse() |> elem(0)}
  end

  defp run_action({direction, amount}, map_info) do
    1..amount
    |> Enum.reduce(map_info, fn _, acc ->
      move(acc, direction)
    end)
  end

  defp move(map_info, direction) do
    {head_coords, head_moves, tail_coords, tail_moves} = map_info

    # Head
    head_coords = move_head(head_coords, direction)
    head_moves = Map.update(head_moves, head_coords, 1, &(&1 + 1))

    # Tail
    tail_coords = move_tail(tail_coords, head_coords)
    tail_moves = Map.update(tail_moves, tail_coords, 1, &(&1 + 1))
    {head_coords, head_moves, tail_coords, tail_moves}
  end

  defp move_head({x, y}, direction) do
    case direction do
      "U" -> {x, y - 1}
      "D" -> {x, y + 1}
      "L" -> {x - 1, y}
      "R" -> {x + 1, y}
    end
  end

  defp move_tail({tail_x, tail_y}, {head_x, head_y}) do
    diff_x = head_x - tail_x
    diff_y = head_y - tail_y

    cond do
      abs(diff_x) < 2 && abs(diff_y) < 2 ->
        {tail_x, tail_y}

      true ->
        {move_step(tail_x, diff_x), move_step(tail_y, diff_y)}
    end
  end

  defp move_step(pos, diff) do
    case diff do
      0 -> pos
      d when d < 0 -> pos - 1
      d when d > 0 -> pos + 1
    end
  end

  defp run_action_b({direction, amount}, map_info) do
    1..amount
    |> Enum.reduce(map_info, fn _, acc ->
      move_b(acc, direction)
    end)
  end

  defp move_b(map_info, direction) do
    {head_coords, head_moves, tail_coords_map, tail_moves_map} = map_info

    # Head
    head_coords = move_head(head_coords, direction)
    head_moves = Map.update(head_moves, head_coords, 1, &(&1 + 1))

    # Tails
    {tail_coords_map, tail_moves_map} =
      0..8
      |> Enum.reduce({tail_coords_map, tail_moves_map}, fn index, {t_c_m, t_m_m} ->
        tail_coords = Map.get(t_c_m, index, {0, 0})

        tail_coords =
          move_tail(
            tail_coords,
            if index == 0 do
              head_coords
            else
              Map.get(t_c_m, index - 1)
            end
          )

        tail_moves = Map.get(t_m_m, index, %{})
        tail_moves = Map.update(tail_moves, tail_coords, 1, &(&1 + 1))

        {Map.put(t_c_m, index, tail_coords), Map.put(t_m_m, index, tail_moves)}
      end)

    {head_coords, head_moves, tail_coords_map, tail_moves_map}
  end

  def solve_b do
    {_, _, _, tail_moves_map} =
      AOC.Utilities.read_lines('inputs/day9.txt')
      |> Enum.map(&parse_line/1)
      |> Enum.reduce({{0, 0}, %{}, %{}, %{}}, fn action, acc ->
        run_action_b(action, acc)
      end)

    tail_moves_map
    |> Map.get(8)
    |> Map.keys()
    |> Enum.count()
  end
end
