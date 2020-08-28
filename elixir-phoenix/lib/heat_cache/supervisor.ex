defmodule HeatCache.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(HeatCache.Cache, [[name: HeatCache.Cache]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end