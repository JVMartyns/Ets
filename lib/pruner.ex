defmodule Pruner do
  use GenServer

  @table :ets_cache

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    GenServer.cast(__MODULE__, :test)
    {:ok, 1}
  end

  def handle_cast(:test, _) do
    :ets_cache
    |> :ets.tab2list()
    |> Enum.map(&apply_cache/1)

    {:noreply, nil}
  end

  defp apply_cache([]), do: nil
  defp apply_cache({_, %{"ttl" => nil}}), do: nil

  defp apply_cache({key, %{"ttl" => ttl}}) do
    if expired?(ttl) do
      :ets.delete(@table, key)
    end
  end

  defp expired?(ttl) do
    DateTime.utc_now()
    |> DateTime.compare(ttl)
    |> case do
      :lt -> false
      _ -> true
    end
  end
end
