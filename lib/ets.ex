defmodule Ets do
  @moduledoc """
    This module uses Erlang Term Storage to create an in-memory table called `:ets_cache` and provides a simple and intuitive way to store the temporary cache.
  """
  use GenServer

  @table :ets_cache

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(stack) do
    with @table <- :ets.new(@table, [:set, :public, :named_table]) do
      {:ok, stack}
    end
  end

  @spec member?(any) :: boolean
  @doc """
    Check if key exist on :ets_cache table.
    returns true if exists or false if not exists

    ## Example

        Ets.member?("key")
        #=> true
  """
  def member?(key), do: :ets.member(@table, key)

  @spec get(any) :: {:ok, map} | {:error, binary()}
  @doc """
    returns: `{:ok, %{"key" => "value"}}` if key exist or `{:error, "Key does not exist!"}` if key does not exist.

    ## Example
        Ets.get("key")
        #=> {:ok, %{"key" => "value"}}
  """
  def get(key) do
    with true <- member?(key),
         [{key, value}] <- :ets.lookup(@table, key) do
      {:ok, Map.new([{key, value}])}
    else
      _error ->
        {:error, "Key does not exist!"}
    end
  end

  @spec get_all :: {:ok, map()}
  @doc """
    returns a tuple of {:ok, map} with all keys and values from `:ets_cache` table

    ## Example
        Ets.all()
        #=> {:ok, %{"key_1" => "value_1", "key_2" => "value_2"}}
  """
  def get_all, do: {:ok, Map.new(:ets.tab2list(:ets_cache))}

  @spec insert(any, any) :: {:ok, map} | {:error, binary()}
  @doc """
    Inserts a key and a value into the table.
    Returns an error if key has already exist.

    ## Example
        Ets.insert("key", "value")
        #=> {:ok, %{"key" => "value"}}
  """
  def insert(key, value) do
    with false <- member?(key),
         true <- :ets.insert(@table, {key, value}) do
      {:ok, Map.new([{key, value}])}
    else
      _error -> {:error, "Key already exist!"}
    end
  end

  @spec insert(any, any, non_neg_integer()) :: {:ok, map} | {:error, binary()}
  @doc """
    Inserts a key and a value into the table.
    Set a lifetime in milliseconds.
    After the set time, the key will be deleted
    Returns an error if key has already exist.

    ## Example
        Ets.insert("key", "value", 10000)
        #=> {:ok, %{"key" => "value"}}
  """
  def insert(key, value, ttl) do
    with {:ok, result} <- insert(key, value),
         {:ok, _} <- :timer.apply_after(ttl, __MODULE__, :delete, [key]) do
      {:ok, result}
    end
  end

  @spec update(any, any) :: {:ok, map} | {:error, binary()}
  @doc """
    Updates the value of an existing key or returns an error if the key does not exist
    ## Example
        Ets.update("key", "value")
        #=> {:ok, %{"key" => "value"}}
  """
  def update(key, value) do
    with true <- member?(key),
         true <- :ets.insert(@table, {key, value}) do
      {:ok, Map.new([{key, value}])}
    else
      _error -> {:error, "Key does not exist!"}
    end
  end

  @spec delete(any) :: {:ok, any()} | {:error, binary()}
  @doc """
    Updates the value of an existing key or returns an error if the key does not exist
    ## Example
        Ets.delete("key")
        #=> {:ok, %{"deleted" => %{"key" => "value"}}}
  """
  def delete(key) do
    with {:ok, value} <- get(key),
         true <- :ets.delete(@table, key) do
      {:ok, %{"deleted" => value}}
    else
      _error ->
        {:error, "Key does not exist!"}
    end
  end

  @spec clear_table :: {:ok, map()}
  @doc """
    Delete all keys from the table
    ## Example
        Ets.clear_table()
        #=> {:ok, %{"deleted" => %{"key" => "value"}}}
  """
  def clear_table do
    with {:ok, value} <- get_all(),
         true <- :ets.delete_all_objects(@table) do
      {:ok, %{"deleted" => value}}
    end
  end
end
