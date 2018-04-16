defmodule Huey.LightUpdater do
  import Huey.Huex

  alias Huey.{Light, Color}

  def turn_on(light) do
    update(light, :turn_on)
  end

  def turn_off(light) do
    update(light, :turn_off)
  end

  def set_color(light, %{h: h, s: s, b: b}) do
    update(light, :set_color, [{Color.hue_to_int(h), s, b}])
  end

  def set_brightness(light, brightness) do
    update(light, :set_brightness, [brightness])
  end

  defp update(light, method, args \\ []) do
    connection = light.connection
    apply(connection.huex, method, [connection.bridge, light.number] ++ args)
    |> handle_response(light)
  end
end
