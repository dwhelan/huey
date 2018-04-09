defmodule Huey.LightTest do
  use ExUnit.Case, asnyc: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures")
    HTTPoison.start()
  end
#
#  test "can turn a light on" do
#    use_cassette "turn_light_on" do
#      bridge = Huey.Bridge.connect("192.168.0.111")
#      response = Huey.Light.turn_on(bridge, 1)
#      assert {:ok, _} = response
#    end
#  end
end