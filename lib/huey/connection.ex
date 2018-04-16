defmodule Huey.Connection do
  defstruct bridge: nil, huex: Huex

  import Huey.Huex
  alias Huey.Connection
  alias Huex.Bridge

  def authorize(host, device_type, huex \\ Huex) do
    bridge = huex.authorize(%Bridge{host: host}, device_type)
    handle_response(bridge, %Connection{bridge: bridge, huex: huex})
  end

  def create(host, username, huex \\ Huex) do
    bridge = %Bridge{host: host, username: username}
    %Connection{bridge: bridge, huex: huex}
  end
end
