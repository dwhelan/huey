defmodule Huey.LightUpdaterTest do
  use ExUnit.Case, asnyc: true

  alias Huey.{Connection, Light, LightUpdater, Color, LightUpdaterTest}
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
  def light_number, do: 42
  def bridge, do: TF.bridge

  defmodule HuexDouble2 do
    def assert_args(bridge, light_number) do
      assert bridge == LightUpdaterTest.bridge()
      assert light_number == LightUpdaterTest.light_number()
    end

    def error(message) do
      %{
        status: :error,
        error: %{
          "description" => message
        }
      }
    end
  end

  describe "turn on" do
    test "successfully" do
      defmodule TurnOnSuccess do
        import HuexDouble2

        def turn_on(bridge, light_number) do
          assert_args(bridge, light_number)
          {:ok, bridge}
        end
      end

      light = create_light(TurnOnSuccess)
      assert {:ok, light} == LightUpdater.turn_on(light)
    end

    test "with error" do
      defmodule TurnOnError do
        import HuexDouble2

        def turn_on(_, _) do
          error("error message")
        end
      end

      light = create_light(TurnOnError)
      assert {:error, "error message"} == LightUpdater.turn_on(light)
    end
  end

  describe "turn off" do
    test "successfully" do
      defmodule TurnOffSuccess do
        import HuexDouble2

        def turn_off(bridge, light_number) do
          assert_args(bridge, light_number)
          {:ok, bridge}
        end
      end

      light = create_light(TurnOffSuccess)
      assert {:ok, light} == LightUpdater.turn_off(light)
    end

    test "with error" do
      defmodule TurnOffError do
        import HuexDouble2

        def turn_off(_, _) do
          error("error message")
        end
      end

      light = create_light(TurnOffError)
      assert {:error, "error message"} == LightUpdater.turn_off(light)
    end
  end

  describe "set color" do
    test "successfully" do
      light = light_expect(:set_color, [{Color.hue_to_int(15), 254, 254}])
      assert {:ok, %Light{}} = LightUpdater.set_color(light, %{h: 15, s: 254, b: 254})
    end

    test "with error" do
      light = light_expect_error(:set_color, [{2730, 254, 254}])
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


  defp create_light(huex_double) do
    %Light{connection: %Connection{bridge: TF.bridge, huex: huex_double}, number: @light_number}
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