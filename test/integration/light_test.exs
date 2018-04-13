defmodule Huey.Integration.LightTest do
  use ExUnit.Case, asnyc: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney, clear_mock: true

  alias Huey.Light
  alias TestFixture, as: TF

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures")
    HTTPoison.start()
  end

  defp test_light(number \\ 1) do
    Light.create(TF.connection(), number)
  end

  test "can turn a light on" do
    use_cassette "turn_light_on" do
      assert {:ok, %Light{}} = Light.turn_on(test_light())
    end
  end

  test "cannot turn on light that doesn't exist" do
    use_cassette "turn_bad_light_on" do
      assert {:error, _} = Light.turn_on(test_light(42))
    end
  end

  test "can turn a light off" do
    use_cassette "turn_light_off" do
      assert {:ok, %Light{}} = Light.turn_off(test_light())
    end
  end

  test "cannot turn off light that doesn't exist" do
    use_cassette "turn_bad_light_off" do
      assert {:error, "resource, /lights/42/state, not available"} = Light.turn_off(test_light(42))
    end
  end

  test "can change the color of a light" do
    use_cassette "change_color" do
      assert {:ok, %Light{}} = Light.set_color(test_light(), %{h: 15, s: 254, b: 254})
    end
  end

  test "can set brightness of a light" do
    use_cassette "change_brightness" do
      assert {:ok, %Light{}} = Light.set_brightness(test_light(), 0.99)
    end
  end
end