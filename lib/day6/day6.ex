defmodule TuningTrouble do
  def solve(file_path) do
    file_path
    |> parse_input()
    |> find_marker()
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.trim()
    |> String.graphemes()
  end

  # Part one: 4
  # Part two: 14
  defp find_marker(chars) do
    {start, rest} = Enum.split(chars, 4)

    find_marker(start, rest, 4)
  end

  defp find_marker(_current, [], _count), do: -1

  defp find_marker(current, rest, count) do
    if not has_duplicates?(current) do
      count
    else
      [_h_current | t_current] = current
      [h_rest | t_rest] = rest

      find_marker(t_current ++ [h_rest], t_rest, count + 1)
    end
  end

  defp has_duplicates?(list), do: list != Enum.uniq(list)
end

# TuningTrouble.solve("./lib/day6/input.txt")
