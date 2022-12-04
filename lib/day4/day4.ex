defmodule CampCleanup do
  def solve(file_path) do
    file_path
    |> parse_input()
    # |> Stream.filter(&contains?/1)
    |> Stream.filter(&overlaps?/1)
    |> Enum.count()
  end

  defp parse_input(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(fn ranges -> Enum.map(ranges, &parse_range/1) end)
  end

  defp parse_range(range) do
    [start, finish] = String.split(range, "-")
    {String.to_integer(start), String.to_integer(finish)}
  end

  # Part one
  defp contains?([range1, range2]) do
    set1 = MapSet.new(range_from_tuple(range1))
    set2 = MapSet.new(range_from_tuple(range2))

    MapSet.subset?(set1, set2) or MapSet.subset?(set2, set1)
  end

  # Part two
  defp overlaps?([range1, range2]) do
    set1 = MapSet.new(range_from_tuple(range1))
    set2 = MapSet.new(range_from_tuple(range2))

    intersect = MapSet.intersection(set1, set2)

    MapSet.size(intersect) > 0
  end

  defp range_from_tuple({start, finish}), do: start..finish
end
