defmodule Ets.Get do
  @table :ets_cache

  def call(key) do
    case :ets.lookup(@table, key) do
      [{^key, values}] ->
        {:ok, values}

      [] ->
        {:error, :not_found}
    end
  end
end
