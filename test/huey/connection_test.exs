defmodule Huey.ConnectionTest do
  use ExUnit.Case, asnyc: true

  alias Huey.Connection
  alias Huex.Bridge

  test "connect" do
    {:ok, connection} = Connection.create("host", "username")
    assert connection.bridge.host == "host"
    assert connection.bridge.username == "username"
    assert connection.huex == Huex
  end

  test "connect with Huex double" do
    {:ok, connection} = Connection.create("host", "username", :HuexDouble)
    assert connection.huex == :HuexDouble
  end
end
