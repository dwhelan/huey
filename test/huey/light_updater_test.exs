defmodule Huey.LightUpdaterTest do
  use ExUnit.Case, asnyc: true

  alias Huey.{Light, LightUpdater}
  alias Huey.TestFixture, as: TF

  describe "turn on" do
    test "successfully" do
      defmodule TurnOn do
        def turn_on(bridge, light_number) do
          assert bridge == TF.bridge()
          assert light_number == 42
          bridge
        end
      end

      light = create_light(TurnOn, 42)

      assert {:ok, light} == LightUpdater.turn_on(light)
    end

    test "with error" do
      defmodule TurnOnError do
        def turn_on(_, _) do
          TF.bridge_error("error message")
        end
      end

      light = create_light(TurnOnError)

      assert {:error, "error message"} == LightUpdater.turn_on(light)
    end
  end

  describe "turn off" do
    test "successfully" do
      defmodule TurnOff do
        def turn_off(bridge, light_number) do
          assert bridge == TF.bridge()
          assert light_number == 42
          bridge
        end
      end

      light = create_light(TurnOff, 42)

      assert {:ok, light} == LightUpdater.turn_off(light)
    end

    test "with error" do
      defmodule TurnOffError do
        def turn_off(_, _) do
          TF.bridge_error("error message")
        end
      end

      light = create_light(TurnOffError)

      assert {:error, "error message"} == LightUpdater.turn_off(light)
    end
  end

  describe "set color" do
    test "successfully" do
      defmodule SetColor do
        def set_color(bridge, light_number, hsb) do
          assert bridge == TF.bridge()
          assert light_number == 42
          assert hsb == {Huey.Color.hue_to_int(15), 16, 17}
          bridge
        end
      end

      light = create_light(SetColor, 42)

      assert {:ok, light} == LightUpdater.set_color(light, %{h: 15, s: 16, b: 17})
    end

    test "with error" do
      defmodule SetColorError do
        def set_color(_, _, _) do
          TF.bridge_error("error message")
        end
      end

      light = create_light(SetColorError)

      assert {:error, "error message"} == LightUpdater.set_color(light, %{h: 15, s: 254, b: 254})
    end
  end

  describe "set brightness" do
    test "successfully" do
      defmodule SetBrightness do
        def set_brightness(bridge, light_number, brightness) do
          assert bridge == TF.bridge()
          assert light_number == 42
          assert brightness == 0.5
          bridge
        end
      end

      light = create_light(SetBrightness, 42)

      assert {:ok, light} == LightUpdater.set_brightness(light, 0.5)
    end

    test "with error" do
      defmodule SetBrightnessError do
        def set_brightness(_, _, _) do
          TF.bridge_error("error message")
        end
      end

      light = create_light(SetBrightnessError)

      assert {:error, "error message"} == LightUpdater.set_brightness(light, 0.5)
    end
  end

  defp create_light(huex, light_number \\ 1) do
    connection = TF.connection(huex)
    %Light{connection: connection, number: light_number}
  end
end
