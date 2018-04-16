defmodule Huey.Connection do
  defstruct bridge: nil, huex: Huex

  alias Huex.Bridge

  def create(host, username, huex \\ Huex) do
    bridge = %Bridge{host: host, username: username}
    %Huey.Connection{bridge: bridge, huex: huex}
  end
end
