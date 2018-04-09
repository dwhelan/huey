defmodule HueyTest do
  use ExUnit.Case
  doctest Huey

  test "greets the world" do
    assert Huey.hello() == :world
  end

  test "fact(0) should be 1" do
    assert Huey.fact(0) == 1
  end

  test "fact(1) should be 1" do
    assert Huey.fact(1) == 1
  end

  test "fact(3) should be 6" do
    assert Huey.fact(3) == 6
  end

  test "fact(4) should be 24" do
    assert Huey.fact(4) == 24
  end
end
