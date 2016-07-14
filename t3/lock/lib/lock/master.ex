defmodule Lock.Master do
  def run do
    step
  end

  def step(queue \\ [], current \\ nil) do
    receive do
      {:acquire, pid} -> acquire(queue, current, pid)
      {:release, pid} -> release(queue, current, pid)
      :exit -> nil
      _ -> step(queue, current)
    end
  end

  def acquire(queue, nil, pid) do
    send pid, :grant
    step(queue, pid)
  end
  def acquire(queue, current, pid), do: step(queue ++ [pid], current)

  def release([], curr, curr), do: step([], nil)
  def release([next|queue], curr, curr) do
    send next, :grant
    step(queue, next)
  end
  def release(queue,curr,_), do: step(queue,curr)
end
