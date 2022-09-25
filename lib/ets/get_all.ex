defmodule Ets.GetAll do
  def call do
    :ets_cache
    |> :ets.tab2list()
    |> Enum.map(fn {_key, values} ->
      values
    end)
  end
end
