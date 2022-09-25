defmodule Ets.Table do
  use Task, restart: :permanent

  @table :ets_cache

  def start_link do
    Task.start_link(&init/0)
  end

  def init do
    :ets.new(@table, [:set, :public, :named_table])
  end
end
