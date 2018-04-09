defmodule Huey.Bridge do
  def authorize(ip, devicetype) do
    ip
    |> Huex.connect()
    |> Huex.authorize(devicetype)
#    "xOYF2J7wjNk7SP2ddvqJLCwa10I8OTQO5R1hVofb"
  end
end