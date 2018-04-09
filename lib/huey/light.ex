defmodule Huey.Light do
  def turn_on(bridge, light_number) do
    {:ok, Huex.turn_on(bridge, light_number)}
  end

  def turn_off(bridge, light_number) do
    {:ok, Huex.turn_off(bridge, light_number)}
  end
end
