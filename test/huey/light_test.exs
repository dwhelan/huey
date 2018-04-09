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
      response = TF.bridge |> Light.turn_on(1)
      assert {:ok, _} = response
    end
  end

  test "can turn a light off" do
    use_cassette "turn_light_off" do
      response = TF.bridge |> Light.turn_off(1)
      assert {:ok, _} = response
    end
  end


end