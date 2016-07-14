defmodule Lock.Writer do
  import Lock.Utils
  def run(master, name, remaining) do
    :random.seed(process_seed)
    do_writer(master, name, remaining)
  end

  defp do_writer(master, name, 0), do: nil
  defp do_writer(master, name, remaining) do
    {:ok, file} = File.open("chat.txt", [:write, :append])

    # Write many times so it flushes in parts
    # This is just to create a race condition even on single-core computers
    acquire(master)
    IO.write(file, name)
    IO.write(file, "is writing")
    IO.write(file, "\n")
    release(master)

    Process.sleep(:random.uniform(1000))
    do_writer(master, name, remaining - 1)
  end

  defp release(master), do: send master, {:release, self}

  defp acquire(master) do
    send master, {:acquire, self}
    wait_grant
  end

  defp wait_grant() do
    receive do
      :grant -> true
      _ -> wait_grant
    end
  end
end
