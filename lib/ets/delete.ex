defmodule Ets.Delete do
  @table :ets_cache

  alias Ets.Get

  def call(key) do
    with {:ok, value} <- Get.call(key),
         true <- :ets.delete(@table, key) do
      {:ok, %{"deleted" => value}}
    end
  end
end
