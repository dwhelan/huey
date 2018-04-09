defmodule Huey.BridgeTest do
  use ExUnit.Case, asnyc: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
  end

  test "authorize creates a username" do
    use_cassette "authorize" do
      IO.inspect bridge = Huey.Bridge.authorize("192.168.0.111", "foobar")
      assert bridge.username == "6I7LnygLAG95Z1OoNjOko9lgoUgZfNWJUaGk1OcD"
    end
  end
end
