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
      {:ok, username} = Bridge.authorize(TestFixture.host(), "foobar")
      assert username == TestFixture.username()
    end
  end

  test "authorize warns to press the button when you forget!" do
    use_cassette "button_not_pressed" do
      {:error, message} = Bridge.authorize(TestFixture.host(), "foobar")
      assert message == "link button not pressed"
    end
  end

  test "connect established" do
    {:ok, bridge} = Bridge.connect(TestFixture.host(), "FJtuwhryNZLot-HGCdn0KkV3A-T0m9ad1OmT-512")
    assert bridge.host == TestFixture.host();
    assert bridge.username == TestFixture.username()
  end
end
