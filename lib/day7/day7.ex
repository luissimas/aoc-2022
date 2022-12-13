defmodule NoSpaceLeftOnDevice do
  def solve(file_path) do
    file_path
    |> File.stream!()
  end
end
