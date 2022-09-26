defmodule Ets.Pruner do
  use GenServer

  @table :ets_cache
  @time 500

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok, prune()}
  end

  def prune do
    @table
    |> :ets.tab2list()
    |> Enum.map(&apply_cache/1)

    :timer.apply_after(@time, __MODULE__, :prune, [])
  end

  def apply_cache({key, %{"ttl_reference" => ttl_reference}}) do
    if :os.system_time(:second) > ttl_reference do
      :ets.delete(@table, key)
    end
  end

  def apply_cache(_), do: nil
end
