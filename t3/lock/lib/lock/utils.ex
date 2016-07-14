defmodule Lock.Utils do
  def process_seed do
    # Trick to seed each process uniquely
    {a, _} = self
    |> :erlang.pid_to_list
    |> :erlang.list_to_binary
    |> String.split(".")
    |> Enum.drop(1)
    |> List.first
    |> Integer.parse

    {_, b, c} = :erlang.now()

    {a,b,c}
  end
end
