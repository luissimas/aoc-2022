defmodule CalorieCounting do
  def solve(file_path) do
    file_path
    |> parse_input()
    |> Stream.map(&Enum.sum/1)
    |> Enum.sort(&(&1 > &2))
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp parse_input(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&Integer.parse/1)
    |> Stream.map(fn
      {number, _} -> number
      :error -> :error
    end)
    |> Stream.chunk_by(&(&1 == :error))
    |> Stream.reject(&(&1 == [:error]))
  end
end
