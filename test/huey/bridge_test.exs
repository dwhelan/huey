defmodule Huey.BridgeTest do
  use ExUnit.Case, asnyc: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures")
    HTTPoison.start()
  end

  test "authorize creates a username" do
    use_cassette "authorize" do
      {:ok, username} = Huey.Bridge.authorize("192.168.0.111", "foobar")
      assert username == "FJtuwhryNZLot-HGCdn0KkV3A-T0m9ad1OmT-512"
    end
  end

  test "authorize warns to press the button when you forget!" do
    use_cassette "button_not_pressed" do
      {:error, message} = Huey.Bridge.authorize("192.168.0.111", "foobar")
      assert message == "link button not pressed"
    end
  end
end
