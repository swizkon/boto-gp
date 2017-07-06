defmodule HeatCache.Cache do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [
      {:ets_table_name, :link_cache_table},
      {:log_limit, 1_000}
    ], opts)
  end

  def fetch(circuit_id, default_value_function) do
    case get(circuit_id) do
      {:not_found} -> set(circuit_id, default_value_function.())
      {:found, result} -> result
    end
  end

  defp get(circuit_id) do
    case GenServer.call(__MODULE__, {:get, circuit_id}) do
      [] -> {:not_found}
      [{_circuit_id, result}] -> {:found, result}
    end
  end

  def set(circuit_id, value) do
    GenServer.call(__MODULE__, {:set, circuit_id, value})
  end

  # GenServer callbacks

  def handle_call({:get, circuit_id}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    result = :ets.lookup(ets_table_name, circuit_id)
    {:reply, result, state}
  end

  def handle_call({:set, circuit_id, value}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    true = :ets.insert(ets_table_name, {circuit_id, value})
    {:reply, value, state}
  end

  def init(args) do
    [{:ets_table_name, ets_table_name}, {:log_limit, log_limit}] = args

    :ets.new(ets_table_name, [:named_table, :set, :private])

    {:ok, %{log_limit: log_limit, ets_table_name: ets_table_name}}
  end

end


#    circuit = Repo.get!(Circuit, id)
#    circuit.datamap["heat"]