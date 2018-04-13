defmodule Huey.LightTest do
  use ExUnit.Case, asnyc: true

  alias Huey.{Connection, Light}

  defmodule Expectation do
    defstruct [expect: nil, response: nil]
  end

  defmodule HuexDouble do
    def turn_on(%Expectation{} = expectation, light_number) do
      assert {:turn_on, [_, ^light_number]} = expectation.expect
      expectation.response
    end

    def turn_off(%Expectation{} = expectation, light_number) do
      assert {:turn_off, [_, ^light_number]} = expectation.expect
      expectation.response
    end
  end

  @light_number 42

  test "turn on" do
    light = light_double(:turn_on)
    assert {:ok, %Light{}} = Light.turn_on(light)
  end

  test "turn on with error" do
    light = light_double(:turn_on, "error message")
    assert {:error, "error message"} == Light.turn_on(light)
  end

  test "turn off" do
    light = light_double(:turn_off)
    assert {:ok, %Light{}} = Light.turn_off(light)
  end

  test "turn off with error" do
    light = light_double(:turn_off, "error message")
    assert {:error, "error message"} == Light.turn_off(light)
  end

  defp expect(method, error_message) do
    expect(
      method,
      [%Expectation{}, @light_number],
      %{
        status: :error,
        error: %{
          "description" => error_message
        }
      }
    )
  end

  defp expect(method) do
    expect(method, [%Expectation{}, @light_number], %{status: :ok})
  end

  defp expect(method, args, response) do
    %Expectation{expect: {method, args}, response: response}
  end

  defp light_double(%Expectation{} = expectation) do
    connection = %Connection{bridge: expectation, huex: HuexDouble}
    Light.create(connection, @light_number)
  end

  defp light_double(method) do
    method
    |> expect()
    |> light_double()
  end

  defp light_double(method, error_message) do
    method
    |> expect(error_message)
    |> light_double()
  end

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
  test "converts angle to Hue integer" do
    assert Light.hue_to_int(0) == 0
    assert Light.hue_to_int(1) == 182
    assert Light.hue_to_int(360) == 0
    assert Light.hue_to_int(-15) == Light.hue_to_int(345)
    assert Light.hue_to_int(-375) == Light.hue_to_int(345)
  end
end