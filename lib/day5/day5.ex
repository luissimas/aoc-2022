defmodule SupplyStacks do
  def solve(input_file) do
    {stacks, procedure} = parse_input(input_file)

    stacks
    |> apply_procedure_9001(procedure)
    |> tops()
  end

  defp parse_input(input_file) do
    [stacks, _, procedure] =
      input_file
      |> File.stream!()
      |> Enum.chunk_by(&(&1 == "\n"))

    parsed_stacks = stacks |> List.delete_at(-1) |> parse_stacks()
    parsed_procedure = parse_procedure(procedure)

    {parsed_stacks, parsed_procedure}
  end

  defp parse_stacks(stacks) do
    parsed_stacks =
      stacks
      |> Enum.flat_map(&Regex.scan(~r/.{3,4}/, &1))
      |> Enum.map(fn
        [elem] ->
          case Regex.run(~r/[A-Z]/, elem) do
            [parsed] -> parsed
            nil -> nil
          end
      end)
      |> Enum.chunk_every(9)

    for n <- 1..9,
        do: {n, parsed_stacks |> Enum.map(&Enum.at(&1, n - 1)) |> Enum.filter(& &1)},
        into: %{}
  end

  defp parse_procedure(procedure) do
    procedure
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [_, number, _, from, _, to] ->
      {String.to_integer(number), String.to_integer(from), String.to_integer(to)}
    end)
  end

  # Part one
  defp apply_procedure_9000(stacks, procedure) do
    procedure
    |> Enum.reduce(stacks, fn action, acc -> move(acc, action) end)
  end

  # Part two
  defp apply_procedure_9001(stacks, procedure) do
    procedure
    |> Enum.reduce(stacks, fn action, acc -> move_multiple(acc, action) end)
  end

  defp move(stacks, {0, _from, _to}), do: stacks

  defp move(stacks, {count, from, to}) do
    [h | t] = Map.get(stacks, from)

    stacks
    |> Map.put(to, [h | Map.get(stacks, to)])
    |> Map.put(from, t)
    |> move({count - 1, from, to})
  end

  defp move_multiple(stacks, {count, from, to}) do
    {crates, rest} = stacks |> Map.get(from) |> Enum.split(count)

    stacks
    |> Map.put(to, crates ++ Map.get(stacks, to))
    |> Map.put(from, rest)
  end

  defp tops(stacks) do
    Enum.reduce(stacks, "", fn {_k, [h | _t]}, acc -> acc <> h end)
  end
end
