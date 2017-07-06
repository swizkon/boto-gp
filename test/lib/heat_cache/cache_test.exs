defmodule HeatCacheTest do
  use ExUnit.Case

  test "caches and finds the correct data" do
    assert HeatCache.Cache.fetch("A", fn ->
      %{id: 1, long_url: "http://www.example.com"}
    end) == %{id: 1, long_url: "http://www.example.com"}

    assert HeatCache.Cache.fetch("A", fn -> "" end) == %{id: 1, long_url: "http://www.example.com"}
  end
end