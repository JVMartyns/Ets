defmodule Ets.Update do
  @table :ets_cache

  def call(key, value) do
    case :ets.member(@table, key) do
      true ->
        insert(key, value)

      false ->
        {:error, :not_found}
    end
  end

  def call(key, value, ttl) do
    case :ets.member(@table, key) do
      true ->
        insert(key, value, ttl)

      false ->
        {:error, :not_found}
    end
  end

  def insert(key, value) do
    values = :maps.from_list([{key, value}])

    with true <- :ets.insert(@table, {key, values}) do
      {:ok, values}
    end
  end

  def insert(key, value, ttl) do
    values =
      :maps.from_list([
        {key, value},
        {"ttl", ttl},
        {"ttl_reference", :os.system_time(:seconds) + ttl}
      ])

    with true <- :ets.insert(@table, {key, values}) do
      {:ok, values}
    end
  end
end
