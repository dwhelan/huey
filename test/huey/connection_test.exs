defmodule Huey.ConnectionTest do
  use ExUnit.Case, asnyc: true

  alias Huey.Connection
  alias Huex.Bridge

  describe "create" do
    test "should default to use Huex" do
      connection = Connection.create("host", "username")
      assert %Bridge{host: "host", username: "username"} = connection.bridge
      assert connection.huex == Huex
    end

    test "should support Huex double" do
      connection = Connection.create("", "", :HuexDouble)
      assert connection.huex == :HuexDouble
    end
  end

  describe "authorize"do
    test "should update bridge with generated user name" do
      defmodule Authorize do
        def authorize(bridge, _device_type) do
          {:ok, %{bridge | username: "username"}}
        end
      end

      {:ok, connection} = Connection.authorize("host", "device_type", Authorize)
      assert %Bridge{host: "host", username: "username"} = connection.bridge
    end
  end
end
