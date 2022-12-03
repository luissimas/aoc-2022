defmodule RucksackReorganization do
  def solve(file_path) do
    file_path
    |> parse_input()
    # |> find_rucksack_matches()
    |> find_group_matches()
    |> get_priorities()
    |> Enum.sum()
  end

  defp parse_input(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
  end

  defp split_line(line) do
    String.split_at(line, div(String.length(line), 2))
  end

  defp split_to_charlist({left, right}) do
    {to_charlist(left), to_charlist(right)}
  end

  # Part one
  defp find_rucksack_matches(entries) do
    entries
    |> Enum.map(fn items ->
      {left, right} =
        items
        |> split_line()
        |> split_to_charlist()

      left
      |> Enum.filter(&Enum.member?(right, &1))
      |> Enum.uniq()
    end)
  end

  # Part two
  defp find_group_matches(entries) do
    entries
    |> Enum.chunk_every(3)
    |> Enum.map(fn [a, b, c] ->
      a
      |> to_charlist()
      |> Enum.filter(fn item ->
        Enum.member?(to_charlist(b), item) and Enum.member?(to_charlist(c), item)
      end)
      |> Enum.uniq()
    end)
  end

  defp get_priorities(matches) do
    priorities_map =
      (Enum.to_list(?a..?z) ++ Enum.to_list(?A..?Z))
      |> Enum.zip(1..52)
      |> Map.new()

    matches
    # Since each element in matches is a charlist, we need to extract
    # the element to get its integer value, example: 'a' -> ?a
    |> Enum.map(fn [elem] -> elem end)
    |> Enum.map(&priorities_map[&1])
  end
end

# RucksackReorganization.solve("./lib/day3/input.txt")
