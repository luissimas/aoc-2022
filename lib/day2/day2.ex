defmodule RockPaperScissors do
  def solve(file_path) do
    file_path
    |> parse_input()
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  defp parse_input(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [a, b] -> {a, b} end)
  end

  # Scores for part one
  # defp score({"A", "X"}), do: 4
  # defp score({"A", "Y"}), do: 8
  # defp score({"A", "Z"}), do: 3

  # defp score({"B", "X"}), do: 1
  # defp score({"B", "Y"}), do: 5
  # defp score({"B", "Z"}), do: 9

  # defp score({"C", "X"}), do: 7
  # defp score({"C", "Y"}), do: 2
  # defp score({"C", "Z"}), do: 6

  # Scores for part two
  defp score({"A", "X"}), do: 3
  defp score({"A", "Y"}), do: 4
  defp score({"A", "Z"}), do: 8

  defp score({"B", "X"}), do: 1
  defp score({"B", "Y"}), do: 5
  defp score({"B", "Z"}), do: 9

  defp score({"C", "X"}), do: 2
  defp score({"C", "Y"}), do: 6
  defp score({"C", "Z"}), do: 7
end
