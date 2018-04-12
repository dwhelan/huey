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

  def set_color(light, %{h: h, s: s, b: b}) do
    light.bridge
    |> Huex.set_color(light.number, {hue_to_int(h), s, b})
    |> handle_response(light)
  end

  def set_brightness(light, brightness) do
    light.bridge
    |> Huex.set_brightness(light.number, brightness)
    |> handle_response(light)
  end

  def hue_to_int(hue) when hue < 0 do
    hue_to_int(360 + hue)
  end

  def hue_to_int(hue) do
    Kernel.trunc(Kernel.rem(hue, 360) * @one_degree)
  end

  defp handle_response(%{status: :error} = response, _light) do
    {:error, response.error["description"]}
  end

  defp handle_response(_response, light) do
    {:ok, light}
  end

end
