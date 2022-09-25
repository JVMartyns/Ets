defmodule Ets.Insert do
  @table :ets_cache

  def call(key, value) when is_binary(key) do
    values = :maps.from_list([{key, value}])

    case :ets.member(@table, key) do
      false ->
        with true <- :ets.insert(@table, {key, values}) do
          {:ok, values}
        end

      true ->
        {:error, "key already exists!"}
    end
  end

  def call(key, value, ttl) when is_binary(key) do
    values =
      :maps.from_list([
        {key, value},
        {"ttl", ttl},
        {"ttl_reference", :os.system_time(:seconds) + ttl}
      ])

    case :ets.member(@table, key) do
      true ->
        {:error, "key already exists!"}

      false ->
        with true <- :ets.insert(@table, {key, values}) do
          {:ok, values}
        end
    end
  end
end
