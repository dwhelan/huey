defmodule Huey.Connection do
  defstruct bridge: nil, huex: Huex

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

  defp handle_response(%{status: :error} = response, _light) do
    {:error, response.error["description"]}
  end

  defp handle_response(_response, light) do
    {:ok, light}
  end
end
