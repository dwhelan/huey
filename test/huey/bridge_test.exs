defmodule Huey.BridgeTest do
  use ExUnit.Case, asnyc: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Huey.Bridge

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures")
    HTTPoison.start()
  end

  test "authorize creates a username" do
    use_cassette "authorize" do
      {:ok, username} = Bridge.authorize("192.168.0.111", "foobar")
      assert username == "FJtuwhryNZLot-HGCdn0KkV3A-T0m9ad1OmT-512"
    end
  end

  test "authorize warns to press the button when you forget!" do
    use_cassette "button_not_pressed" do
      {:error, message} = Bridge.authorize("192.168.0.111", "foobar")
      assert message == "link button not pressed"
    end
  end

  test "connect established" do
    {:ok, bridge} = Bridge.connect("192.168.0.111", "FJtuwhryNZLot-HGCdn0KkV3A-T0m9ad1OmT-512")
    assert bridge.ip == "192.168.0.111";
    assert bridge.username == "FJtuwhryNZLot-HGCdn0KkV3A-T0m9ad1OmT-512";
  end
end
