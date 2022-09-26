defmodule Ets.GetAll do
  @spec call :: list
  def call do
    :ets_cache
    |> :ets.tab2list()
    |> Enum.map(fn {_key, values} ->
      values
    end)
  end
end
