defmodule Huey.Light do
  defstruct [bridge: nil, number: 0]

  @one_degree 65536 / 360

  def create(bridge, number) do
    %Huey.Light{bridge: bridge, number: number}
  end

  def turn_on(light) do
    light.bridge
    |> Huex.turn_on(light.number)
    |> handle_response(light)
  end

  def turn_off(light) do
    light.bridge
    |> Huex.turn_off(light.number)
    |> handle_response(light)
  end

  defp handle_response(%{status: :error} = response, _light) do
    {:error, response.error["description"]}
  end

  defp handle_response(response, light) do
    {:ok, light}
  end

  # These should be deleted once all functions use a Light

  def turn_on(bridge, light_number) do
    bridge
    |> Huex.turn_on(light_number)
    |> handle_response
  end

  def turn_off(bridge, light_number) do
    bridge
    |> Huex.turn_off(light_number)
    |> handle_response
  end

  def set_color(bridge, light_number, {hue, sat, bri} = hsb_color) do
    bridge
    |> Huex.set_color(light_number, {hue_to_int(hue), sat, bri})
    |> handle_response
  end

  def set_brightness(bridge, light_number, brightness) do
    bridge
    |> Huex.set_brightness(light_number, brightness)
    |> handle_response
  end

  def hue_to_int(hue) when hue < 0 do
    hue_to_int(360 + hue)
  end

  def hue_to_int(hue) do
    Kernel.trunc(Kernel.rem(hue, 360) * @one_degree)
  end

  defp handle_response(%{status: :error} = response) do
    {:error, response.error["description"]}
  end

  defp handle_response(response) do
    {:ok, response}
  end
end
