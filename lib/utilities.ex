defmodule AOC.Utilities do
  def read_lines(path, trim \\ true) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split(~r/[\n|\r\n]/, trim: trim)
  end
end
