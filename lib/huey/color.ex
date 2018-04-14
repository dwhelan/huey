defmodule Huey.Color do
  @one_degree 65536 / 360

  def hue_to_int(hue) when hue < 0 do
    hue_to_int(360 + hue)
  end

  def hue_to_int(hue) do
    trunc(rem(hue, 360) * @one_degree)
  end
end
