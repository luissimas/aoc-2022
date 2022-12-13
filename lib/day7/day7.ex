defmodule NoSpaceLeftOnDevice do
  @total_space 70_000_000
  @needed_space 30_000_000

  def part_one(file_path) do
    file_path
    |> parse_file()
    |> dir_sizes()
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  def part_two(file_path) do
    sizes =
      file_path
      |> parse_file()
      |> dir_sizes()

    current_space = @total_space - Enum.max(sizes)
    space_to_free = @needed_space - current_space

    sizes
    |> Enum.filter(&(&1 >= space_to_free))
    |> Enum.min()
  end

  defp parse_file(file_path) do
    file_path
    |> File.stream!()
    |> Enum.map(&String.trim/1)
  end

  defp dir_sizes(lines) do
    handle_line(lines, [], [], [])
  end

  defp handle_line([], _current, [], acc), do: acc

  defp handle_line([], current, [parent | path], acc),
    do: handle_line([], [current | parent], path, [flat_sum(current) | acc])

  defp handle_line(["$ ls" | rest], current, path, acc), do: handle_line(rest, current, path, acc)

  defp handle_line(["$ cd .." | rest], current, [parent | path], acc),
    do: handle_line(rest, [parent | current], path, [flat_sum(current) | acc])

  defp handle_line(["$ cd " <> _dir | rest], current, path, acc),
    do: handle_line(rest, [], [current | path], acc)

  defp handle_line(["dir" <> _dir | rest], current, path, acc),
    do: handle_line(rest, current, path, acc)

  defp handle_line([file | rest], current, path, acc) do
    [size, _name] = String.split(file)
    handle_line(rest, [String.to_integer(size) | current], path, acc)
  end

  defp flat_sum(list), do: list |> List.flatten() |> Enum.sum()
end
