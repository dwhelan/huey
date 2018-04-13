defmodule Huey.Light do
  defstruct [bridge: nil, number: nil, connection: nil]

  @one_degree 65536 / 360

  def create(%Huex.Bridge{} = bridge, number) do
    %Huey.Light{bridge: bridge, number: number}
  end

  def create(connection, number) do
    %Huey.Light{connection: connection, number: number}
  end

  def turn_on(light) do
    connection = light.connection
    apply(connection.huex, :turn_on, [connection.bridge, light.number])
    |> handle_response(light)
  end

  def turn_off(light) do
    connection = light.connection
    apply(connection.huex, :turn_off, [connection.bridge, light.number])
    |> handle_response(light)
  end

  def set_color(light, %{h: h, s: s, b: b}) do
    connection = light.connection
    apply(connection.huex, :set_color, [connection.bridge, light.number, {hue_to_int(h), s, b}])
    |> handle_response(light)
  end

  def set_brightness(light, brightness) do
    connection = light.connection
    apply(connection.huex, :set_brightness, [connection.bridge, light.number, brightness])
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
