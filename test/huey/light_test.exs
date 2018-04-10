defmodule Huey.LightTest do
  use ExUnit.Case, asnyc: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Huey.Light
  alias TestFixture, as: TF

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures")
    HTTPoison.start()
  end

  test "can turn a light on" do
    use_cassette "turn_light_on" do
      assert {:ok, _} = TF.bridge
                        |> Light.turn_on(1)
    end
  end

  test "cannot turn on light that doesn't exist" do
    use_cassette "turn_bad_light_on" do
      assert {:error, _} = TF.bridge
                           |> Light.turn_on(42)
    end
  end


  test "can turn a light off" do
    use_cassette "turn_light_off" do
      assert {:ok, _} = TF.bridge
                        |> Light.turn_off(1)
    end
  end

  test "cannot turn off light that doesn't exist" do
    use_cassette "turn_bad_light_off" do
      assert {:error, "resource, /lights/42/state, not available"} = TF.bridge
                                                                     |> Light.turn_off(42)
    end
  end

  test "can change the color of a light" do
    use_cassette "change_color" do
      TF.bridge
      |> Light.set_color(1, {15, 254, 254})
    end
  end
end