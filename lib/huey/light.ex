defmodule Huey.Light do
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
    |> Huex.set_color(light_number, {hue * 182, sat, bri})
    |> handle_response
  end

  defp handle_response(%{status: :error} = response) do
    {:error, response.error["description"]}
  end

  defp handle_response(response) do
    {:ok, response}
  end
end
