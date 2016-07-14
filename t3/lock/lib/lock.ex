defmodule Lock do
  alias Lock.{Master, Writer}

  def run(writes_count,worker_count,delay \\ 0) do
    master_pid = spawn(Master, :run, [])

    timeout = writes_count*worker_count*2000

    1..worker_count
    |> Enum.map(fn _ -> Faker.Name.first_name end)
    |> Enum.map(&launch_writer([master_pid, &1, writes_count], delay))
    |> Enum.map(&Task.await(&1, timeout))

    send master_pid, :exit
  end

  def launch_writer(args), do: Task.async(Writer, :run, args)
  def launch_writer(args, 0), do: launch_writer(args)
  def launch_writer(args, delay) do
    task = launch_writer(args)
    Process.sleep(delay)
    task
  end
end
