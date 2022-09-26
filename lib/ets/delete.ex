defmodule Ets.Delete do
  @table :ets_cache

  def call(key) do
    with [{^key, value}] <- :ets.lookup(@table, key),
         true <- :ets.delete(@table, key) do
      {:ok, %{"deleted" => value}}
    else
      [] ->
        {:error, "Key does not exist!"}
    end
  end
end
