defmodule RopeBridge do
  def part_one(file_path) do
    file_path
    |> parse_input()
    |> move({0, 0}, [{0, 0}], [])
    |> Enum.uniq()
    |> Enum.count()
  end

  def part_two(file_path) do
    file_path
    |> parse_input()
    |> move({0, 0}, Enum.map(1..9, fn _ -> {0, 0} end), [])
    |> Enum.uniq()
    |> Enum.count()
  end

  defp parse_input(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [dir, count] -> {dir, String.to_integer(count)} end)
  end

  defp move([], _head, tail, acc), do: [List.last(tail) | acc]

  defp move([{dir, 1} | rest], head, tail, acc) do
    {new_head, new_tail} = apply_move(dir, head, tail)

    move(rest, new_head, new_tail, [List.last(tail) | acc])
  end

  defp move([{dir, count} | rest], head, tail, acc) do
    {new_head, new_tail} = apply_move(dir, head, tail)

    move([{dir, count - 1} | rest], new_head, new_tail, [List.last(tail) | acc])
  end

  defp apply_move(dir, {x_h, y_h}, tail) do
    new_head =
      case dir do
        "R" -> {x_h + 1, y_h}
        "L" -> {x_h - 1, y_h}
        "U" -> {x_h, y_h + 1}
        "D" -> {x_h, y_h - 1}
      end

    [head | tail] = handle_tail(new_head, tail, [new_head]) |> Enum.reverse()

    {head, tail}
  end

  defp handle_tail(_head, [], acc), do: acc

  defp handle_tail({x_h, y_h}, [{x_t, y_t} = tail | rest], acc) do
    new_head =
      case {x_h - x_t, y_h - y_t} do
        # Touching, don't move
        {x, y} when x <= 1 and x >= -1 and y <= 1 and y >= -1 -> tail
        # Linear movement
        {2, 0} -> {x_t + 1, y_t}
        {0, 2} -> {x_t, y_t + 1}
        {-2, 0} -> {x_t - 1, y_t}
        {0, -2} -> {x_t, y_t - 1}
        # Diagonal movement
        {2, 1} -> {x_t + 1, y_t + 1}
        {1, 2} -> {x_t + 1, y_t + 1}
        {-2, -1} -> {x_t - 1, y_t - 1}
        {-1, -2} -> {x_t - 1, y_t - 1}
        {-2, 1} -> {x_t - 1, y_t + 1}
        {1, -2} -> {x_t + 1, y_t - 1}
        {2, -1} -> {x_t + 1, y_t - 1}
        {-1, 2} -> {x_t - 1, y_t + 1}
        {2, 2} -> {x_t + 1, y_t + 1}
        {-2, -2} -> {x_t - 1, y_t - 1}
        {-2, 2} -> {x_t - 1, y_t + 1}
        {2, -2} -> {x_t + 1, y_t - 1}
      end

    handle_tail(new_head, rest, [new_head | acc])
  end
end
