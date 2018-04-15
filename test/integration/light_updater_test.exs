defmodule Huey.Integration.LightUpdaterTest do
  use ExUnit.Case, asnyc: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney, clear_mock: true

  alias Huey.{Light, LightUpdater}
  alias Huey.TestFixture, as: TF

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/light_updater")
    HTTPoison.start()
  end

  test "turn on" do
    use_cassette "turn_on" do
      LightUpdater.turn_on(test_light())
    end
  end

  test "turn off" do
    use_cassette "turn_off" do
      LightUpdater.turn_off(test_light())
    end
  end

  test "set color" do
    use_cassette "set_color" do
      LightUpdater.set_color(test_light(), %{h: 15, s: 254, b: 254})
    end
  end

  test "set brightness" do
    use_cassette "set_brightness" do
      LightUpdater.set_brightness(test_light(), 0.99)
    end
  end

  defp test_light() do
    %Light{connection: TF.connection(), number: 1}
  end
end
