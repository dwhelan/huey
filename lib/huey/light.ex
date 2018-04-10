defmodule Huey.Light do
  @one_degree 65536 / 360

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
