defmodule Ets.Table do
  use GenServer

  @table :ets_cache

  def start_link(_state) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_stack) do
    with @table <- :ets.new(@table, [:set, :public, :named_table]) do
      {:ok, :ets_cache}
    end
  end
end
