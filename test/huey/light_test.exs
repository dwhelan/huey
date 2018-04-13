defmodule Huey.LightTest do
  use ExUnit.Case, asnyc: true

  alias Huey.{Connection, Light}
  alias TestFixture, as: TF

  defmodule BridgeDouble do
    defstruct [expect: nil, response: nil]
  end

  defmodule HuexDouble do
    def turn_on(bridge, light_number) do
      assert {:turn_on, [%BridgeDouble{}, ^light_number]} = bridge.expect
      bridge.response
    end
  end

  test "turn light on" do
    bridge_double = %BridgeDouble{expect: {:turn_on, [%BridgeDouble{}, 1]}, response: {:ok, %BridgeDouble{}}}
    test_light = light_double(bridge_double)
    assert {:ok, %Light{}} = Light.turn_on(test_light)
  end

#  test "turn light off" do
#    bridge_double = %BridgeDouble{expect: {:turn_off, [%BridgeDouble{}, 1]}, response: {:ok, %BridgeDouble{}}}
#    test_light = light_double(bridge_double)
#    assert {:ok, %Light{}} = Light.turn_on(test_light)
#  end

  defp light_double(bridge_double, number \\ 1) do
    connection = %Connection{bridge: bridge_double, huex: HuexDouble}
    Light.create(connection, number)
  end

  defp test_light(number \\ 1) do
    Light.create(TF.bridge(), number)
  end

#  test "cannot turn on light that doesn't exist" do
#    use_cassette "turn_bad_light_on" do
#      assert {:error, _} = Light.turn_on(test_light(42))
#    end
#  end
#
#  test "can turn a light off" do
#    use_cassette "turn_light_off" do
#      assert {:ok, %Light{}} = Light.turn_off(test_light())
#    end
#  end
#
#  test "cannot turn off light that doesn't exist" do
#    use_cassette "turn_bad_light_off" do
#      assert {:error, "resource, /lights/42/state, not available"} = Light.turn_off(test_light(42))
#    end
#  end
#
#  test "can change the color of a light" do
#    use_cassette "change_color" do
#      assert {:ok, %Light{}} = Light.set_color(test_light(), %{h: 15, s: 254, b: 254})
#    end
#  end
#
#  test "can set brightness of a light" do
#    use_cassette "change_brightness" do
#      assert {:ok, %Light{}} = Light.set_brightness(test_light(), 0.99)
#    end
#  end
#
#  test "converts angle to Hue integer" do
#    assert Light.hue_to_int(0) == 0
#    assert Light.hue_to_int(1) == 182
#    assert Light.hue_to_int(360) == 0
#    assert Light.hue_to_int(-15) == Light.hue_to_int(345)
#    assert Light.hue_to_int(-375) == Light.hue_to_int(345)
#  end
end