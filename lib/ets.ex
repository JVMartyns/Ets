defmodule Ets do
  @moduledoc """
    This module uses Erlang Term Storage to create an in-memory table called `:ets_cache`
    and provides a simple and intuitive way to store the temporary cache.
  """

  @doc """
    Check if key exist on :ets_cache table.
    returns true if exists or false if not exists

    ## Example

        Ets.member?("key")
        #=> true
  """
  @spec member?(any) :: boolean
  defdelegate member?(key), to: Ets.Member, as: :call

  @doc """
    returns: `{:ok, %{"key" => "value"}}` if key exist or `{:error, "Key does not exist!"}` if key does not exist.

    ## Example
        Ets.get("key")
        #=> {:ok, %{"key" => "value"}}
  """
  @spec get(binary()) :: {:ok, map} | {:error, binary()}
  defdelegate get(key), to: Ets.Get, as: :call

  @doc """
    returns a tuple of {:ok, map} with all keys and values from `:ets_cache` table

    ## Example
        Ets.all()
        #=> {:ok, %{"key_1" => "value_1", "key_2" => "value_2"}}
  """
  @spec get_all :: list
  defdelegate get_all, to: Ets.GetAll, as: :call

  @doc """
    Inserts a key and a value into the table.
    Returns an error if key has already exist.

    ## Example
        Ets.insert("key", "value")
        #=> {:ok, %{"key" => "value"}}
  """
  @spec insert(binary(), any) :: {:ok, map} | {:error, binary()}
  defdelegate insert(key, value), to: Ets.Insert, as: :call

  @doc """
    Inserts a key and a value into the table.
    Set a lifetime in milliseconds.
    After the set time, the key will be deleted
    Returns an error if key has already exist.

    ## Example
        Ets.insert("key", "value", 10000)
        #=> {:ok, %{"key" => "value"}}
  """
  @spec insert(binary(), any, non_neg_integer()) :: {:ok, map} | {:error, binary()}
  defdelegate insert(key, value, ttl), to: Ets.Insert, as: :call

  @doc """
    Updates the value of an existing key or returns an error if the key does not exist
    ## Example
        Ets.update("key", "value")
        #=> {:ok, %{"key" => "value"}}
  """
  @spec update(binary(), any) :: {:ok, map} | {:error, binary()}
  defdelegate update(key, value), to: Ets.Update, as: :call

  @doc """
    Updates the value of an existing key or returns an error if the key does not exist
    ## Example
        Ets.delete("key")
        #=> {:ok, %{"deleted" => %{"key" => "value"}}}
  """
  @spec delete(binary()) :: {:ok, map()} | {:error, binary()}
  defdelegate delete(key), to: Ets.Delete, as: :call

  @doc """
    Delete all keys from the table
    ## Example
        Ets.clear_table()
        #=> {:ok, %{"deleted" => %{"key" => "value"}}}
  """
  @spec clear_table :: {:ok, map()}
  defdelegate clear_table, to: Ets.ClearTable, as: :call
end
