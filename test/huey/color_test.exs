defmodule Huey.ColorTest do
  use ExUnit.Case, asnyc: true

  alias Huey.Color

  test "converts angle to Hue integer" do
    assert Color.hue_to_int(0) == 0
    assert Color.hue_to_int(1) == 182
    assert Color.hue_to_int(360) == 0
    assert Color.hue_to_int(-15) == Color.hue_to_int(345)
    assert Color.hue_to_int(-375) == Color.hue_to_int(345)
  end
end