defmodule Huey.LightUpdaterTest do
  use ExUnit.Case, asnyc: true

  alias Huey.{Connection, Light, LightUpdater, Color}
  alias TestFixture, as: TF

  defmodule HuexDouble do
    def turn_on(%Expectation{} = expectation, light_number) do
      assert {:turn_on, [_, ^light_number]} = expectation.expect
      expectation.response
    end

    def turn_off(%Expectation{} = expectation, light_number) do
      assert {:turn_off, [_, ^light_number]} = expectation.expect
      expectation.response
    end

    def set_color(%Expectation{} = expectation, light_number, color) do
      assert {:set_color, [_, ^light_number, ^color]} = expectation.expect
      expectation.response
    end

    def set_brightness(%Expectation{} = expectation, light_number, brightness) do
      assert {:set_brightness, [_, ^light_number, ^brightness]} = expectation.expect
      expectation.response
    end
  end

  @light_number 42

  describe "turn on" do
    test "successfully" do
      defmodule TurnOn do
        def turn_on(%{} = _bridge, 42 = _light_number) do
          {:ok, %{}}
        end
      end

      light = create_light(TurnOn, _bridge = %{}, _light_number = 42)
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
        def turn_off(%{} = _bridge, 42 = _light_number) do
          {:ok, %{}}
        end
      end

      light = create_light(TurnOff, _bridge = %{}, _light_number = 42)
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
        def set_color(%{} = _bridge, 42 = _light_number, {hue, 254, 254} = _hsb) do
          assert hue == Color.hue_to_int(15)
          {:ok, %{}}
        end
      end

      light = create_light(SetColor, _bridge = %{}, _light_number = 42)
      assert {:ok, light} = LightUpdater.set_color(light, %{h: 15, s: 254, b: 254})
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
      light = light_expect(:set_brightness, [0.5])
      assert {:ok, %Light{}} = LightUpdater.set_brightness(light, 0.5)
    end

    test "with error" do
      light = light_expect_error(:set_brightness, [0.5])
      assert {:error, "error message"} == LightUpdater.set_brightness(light, 0.5)
    end
  end


  defp create_light(huex_double, bridge \\ TF.bridge(), light_number \\ 42) do
    %Light{connection: %Connection{bridge: bridge, huex: huex_double}, number: light_number}
  end

  defp light_expect(method, args) do
    method
    |> Expectation.expect([%Expectation{}, @light_number] ++ args)
    |> light_double()
  end

  defp light_expect_error(method, args, error_message \\ "error message") do
    method
    |> Expectation.expect_error([%Expectation{}, @light_number] ++ args, error_message)
    |> light_double()
  end

  defp light_double(%Expectation{} = expectation) do
    connection = %Connection{bridge: expectation, huex: HuexDouble}
    %Light{connection: connection, number: @light_number}
  end
end