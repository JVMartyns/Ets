defmodule Ets.Member do
  @spec call(any) :: boolean
  def call(key), do: :ets.member(:ets_cache, key)
end
