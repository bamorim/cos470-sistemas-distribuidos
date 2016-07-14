defmodule Lock.Writer do
  def run(_, _, 0), do: nil
  def run(master, name, remaining) do

    # Write many times so it flushes in parts
    # This is just to create a race condition even on single-core computers
    acquire(master)
    {:ok, file} = File.open("chat.txt", [:write, :append])
    IO.write(file, name)
    IO.write(file, "is writing")
    IO.write(file, "\n")
    File.close(file)
    release(master)

    Process.sleep(:rand.uniform(1000))
    run(master, name, remaining - 1)
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
