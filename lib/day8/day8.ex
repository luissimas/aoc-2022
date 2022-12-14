defmodule TreetopTreeHouse do
  def part_one(file_path) do
    matrix =
      file_path
      |> parse_input()

    coordinates = coordinates(matrix)

    count_visible(matrix, coordinates)
  end

  def part_two(file_path) do
    matrix =
      file_path
      |> parse_input()

    coordinates = coordinates(matrix)

    max_scenic_score(matrix, coordinates)
  end

  defp parse_input(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
  end

  defp coordinates(matrix) do
    width = length(matrix)
    height = matrix |> Enum.at(0) |> length()

    for(i <- 0..(width - 1), j <- 0..(height - 1), do: {i, j})
  end

  defp count_visible(matrix, coordinates) do
    coordinates
    |> Enum.filter(fn {i, j} ->
      current = matrix |> Enum.at(i) |> Enum.at(j)

      {before_row, [_ | after_row]} = matrix |> Enum.at(i) |> Enum.split(j)
      {before_column, [_ | after_column]} = matrix |> Enum.map(&Enum.at(&1, j)) |> Enum.split(i)

      visible?(current, before_row, after_row, before_column, after_column)
    end)
    |> Enum.count()
  end

  defp max_scenic_score(matrix, coordinates) do
    coordinates
    |> Enum.map(fn {i, j} ->
      current = matrix |> Enum.at(i) |> Enum.at(j)

      {before_row, [_ | after_row]} = matrix |> Enum.at(i) |> Enum.split(j)
      {before_column, [_ | after_column]} = matrix |> Enum.map(&Enum.at(&1, j)) |> Enum.split(i)

      scenic_score(current, before_row, after_row, before_column, after_column)
    end)
    |> Enum.max()
  end

  defp visible?(_tree, [], _, _, _), do: true
  defp visible?(_tree, _, [], _, _), do: true
  defp visible?(_tree, _, _, [], _), do: true
  defp visible?(_tree, _, _, _, []), do: true

  defp visible?(tree, before_row, after_row, before_column, after_column) do
    Enum.any?([before_row, after_row, before_column, after_column], fn list ->
      Enum.all?(list, &(&1 < tree))
    end)
  end

  defp scenic_score(tree, before_row, after_row, before_column, after_column) do
    [before_row, before_column]
    |> Enum.map(&Enum.reverse/1)
    |> (&(&1 ++ [after_row, after_column])).()
    |> Enum.map(&count_smaller(tree, &1, 0))
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp count_smaller(_tree, [], acc), do: acc
  defp count_smaller(tree, [current | _rest], acc) when current >= tree, do: acc + 1
  defp count_smaller(tree, [_current | rest], acc), do: count_smaller(tree, rest, acc + 1)
end
