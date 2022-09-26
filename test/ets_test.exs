defmodule EtsTest do
  use ExUnit.Case
  doctest Ets

  @table :ets_cache

  setup do
    EtsCache.start_link([])
    :ok
  end

  describe "member?/1" do
    test "when key exist" do
      :ets.insert(@table, {"key", "value"})
      assert Ets.member?("key") == true
    end

    test "when key does not exist" do
      assert Ets.member?("key") == false
    end
  end

  describe "get/1" do
    test "when key exist, get key and value" do
      :ets.insert(@table, {"key", "value"})
      assert Ets.get("key") == {:ok, "value"}
    end

    test "when key  does not exist, returns an error" do
      assert Ets.get("key") == {:error, "key not found"}
    end
  end

  describe "get_all/0" do
    test "get all keys and values from table" do
      for x <- 1..5 do
        :ets.insert(@table, {"key#{x}", %{"key#{x}" => x}})
      end

      assert Ets.get_all() == [
               %{"key1" => 1},
               %{"key5" => 5},
               %{"key2" => 2},
               %{"key4" => 4},
               %{"key3" => 3}
             ]
    end

    test "When :ets_cache table is empty" do
      assert Ets.get_all() == []
    end
  end

  describe "insert/2" do
    test "insert a key and a value" do
      assert Ets.insert("key", "value") == {:ok, %{"key" => "value"}}
      # assert :ets.lookup(@table, "key") == [{"key", "value"}]
    end

    test "when key already exists" do
      :ets.insert(@table, {"key", "value"})
      assert Ets.insert("key", "value") == {:error, "key already exists!"}
    end
  end

  describe "insert/3" do
    test "insert key, value and expiration time" do
      assert {:ok,
              %{
                "key" => "value",
                "ttl" => 1,
                "ttl_reference" => _
              }} = Ets.insert("key", "value", 1)

      :timer.sleep(1050)
      assert :ets.member(@table, "key") == false
    end

    test "when key already exists" do
      :ets.insert(@table, {"key", "value"})
      assert Ets.insert("key", "value", 10000) == {:error, "key already exists!"}
    end
  end

  describe "update/2" do
    test "update an existent key" do
      :ets.insert(@table, {"key", "value"})
      assert Ets.update("key", "new value") == {:ok, %{"key" => "new value"}}
      assert :ets.lookup(@table, "key") == [{"key", %{"key" => "new value"}}]
    end

    test "when key does not exist" do
      assert Ets.update("key", "new value") == {:error, "key not found"}
    end
  end

  describe "delete/1" do
    test "delete an existent key" do
      :ets.insert(@table, {"key", %{"key" => "value"}})
      assert Ets.delete("key") == {:ok, %{"deleted" => %{"key" => "value"}}}
      assert :ets.lookup(@table, "key") == []
    end

    test "returns an error if key does not exist" do
      assert Ets.delete("key") == {:error, "Key does not exist!"}
    end
  end

  describe("clear_table/0") do
    test "delete all keys from table" do
      :ets.insert(@table, {"key", %{"key" => "value"}})
      assert Ets.clear_table() == {:ok, %{"deleted" => [%{"key" => "value"}]}}
      assert :ets.tab2list(@table) == []
    end

    test "when table in empty" do
      assert Ets.clear_table() == {:ok, %{"deleted" => []}}
    end
  end
end
