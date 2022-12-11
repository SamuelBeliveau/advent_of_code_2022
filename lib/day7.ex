defmodule AOC.Day7 do
  def solve_a do
    AOC.Utilities.read_lines('inputs/day7.txt')
    |> group_commands()
    |> Enum.map(&parse_command_group/1)
    |> build_tree()
    |> calculate_size("/", %{})
    |> Enum.sort_by(fn {_, size} -> size end, :desc)
    |> Enum.map(fn {_, size} -> size end)
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  defp group_commands(lines) do
    chunk_fun = fn line, acc ->
      if String.starts_with?(line, "$") do
        {:cont, Enum.reverse(acc), [line]}
      else
        {:cont, [line | acc]}
      end
    end

    after_fun = fn acc ->
      {:cont, Enum.reverse(acc), []}
    end

    lines |> Enum.chunk_while([], chunk_fun, after_fun) |> Enum.drop(1)
  end

  def parse_command_group(raw) do
    [command | results] = raw

    {parse_action(command), results |> Enum.map(&parse_result/1)}
  end

  defp parse_action(command) do
    [_, action, arg] = Regex.run(~r/\$ ([a-z]*)(?:\s*(\S*))/, command)

    case action do
      "cd" -> {action, arg}
      _ -> {action}
    end
  end

  defp parse_result(result) do
    [_, size, name] = Regex.run(~r/(\S+)(?:\s*(\S*))/, result)

    case size do
      "dir" -> {name, size}
      _ -> {name, size |> Integer.parse() |> elem(0)}
    end
  end

  defp build_tree(commands) do
    commands
    |> Enum.reduce({[], %{}}, fn command, {route, structure} ->
      {action, results} = command

      case action do
        {"cd", "/"} -> {["/"], structure}
        {"cd", ".."} -> {tl(route), structure}
        {"cd", folder} -> {[folder | route], structure}
        {"ls"} -> {route, structure |> Map.put(get_path(route), results)}
      end
    end)
    |> elem(1)
  end

  defp get_path(route) do
    route |> Enum.reverse() |> Path.join()
  end

  defp calculate_size(structure, parent_name, sizes) do
    Map.get(structure, parent_name, [])
    |> Enum.reduce(sizes, fn element, acc ->
      case element do
        {name, "dir"} ->
          full_name = Path.join(parent_name, name)
          acc = calculate_size(structure, full_name, acc)
          subfolder_size = Map.get(acc, full_name)
          Map.update(acc, parent_name, subfolder_size, &(&1 + subfolder_size))

        {_, size} ->
          Map.update(acc, parent_name, size, &(&1 + size))
      end
    end)
  end

  def solve_b do
    structure =
      AOC.Utilities.read_lines('inputs/day7.txt')
      |> group_commands()
      |> Enum.map(&parse_command_group/1)
      |> build_tree()
      |> calculate_size("/", %{})

    total_size = Map.get(structure, "/")
    remaining_size = 70_000_000 - total_size
    to_free_up = 30_000_000 - remaining_size

    structure
    |> Enum.sort_by(fn {_, size} -> size end)
    |> Enum.map(fn {_, size} -> size end)
    |> Enum.filter(&(&1 >= to_free_up))
    |> List.first()
  end
end
