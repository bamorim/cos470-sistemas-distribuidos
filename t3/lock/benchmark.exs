defmodule Benchmark do
  @writes_count 100
  @delays [0, 1000]
  @ks [1,2,4,8,16,32,64,128]
  @times 3

  def measure_one(k, delay) do
    {time, _} = :timer.tc(Lock, :run, [@writes_count, k, delay])
    time
  end

  def measure_many(k,delay) do
    total = 1..@times
    |> Enum.map(fn _ -> measure_one(k,delay) end)
    |> Enum.sum

    mean = total / @times

    IO.puts "#{k},#{delay},#{mean}"
  end

  def run do
    IO.puts "k,delay,mean"
    for k <- @ks, delay <- @delays, do: measure_many(k, delay)
  end
end

Benchmark.run
