defmodule Huey.BridgeTest do
  use ExUnit.Case

  test "authorize creates a username" do
    name = Huey.Bridge.authorize()
    assert name == "xOYF2J7wjNk7SP2ddvqJLCwa10I8OTQO5R1hVofb"
  end
  # xOYF2J7wjNk7SP2ddvqJLCwa10I8OTQO5R1hVofb
end
