defmodule Ets.ClearTable do
  alias Ets.GetAll

  def call do
    with value <- GetAll.call(),
         true <- :ets.delete_all_objects(:ets_cache) do
      {:ok, %{"deleted" => value}}
    end
  end
end
