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

    test "should support a Huex double" do
      connection = Connection.create("", "", :HuexDouble)
      assert connection.huex == :HuexDouble
    end
  end

  describe "authorize"do
    test "should return bridge with generated user name" do
      defmodule Authorize do
        def authorize(bridge, device_type) do
          assert %Bridge{host: "host"} = bridge
          assert device_type == "device_type"
          %{bridge | username: "username"}
        end
      end

      {:ok, connection} = Connection.authorize("host", "device_type", Authorize)
      assert %Bridge{host: "host", username: "username"} = connection.bridge
    end

    test "with error" do
      defmodule AuthorizeError do
        alias Huey.TestFixture, as: TF

        def authorize(_, _) do
          TF.bridge_error("error message")
        end
      end

      assert {:error, "error message"} == Connection.authorize("host", "device_type", AuthorizeError)
    end
  end
end
