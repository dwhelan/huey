defmodule Huey.Bridge do
  def authorize(ip, devicetype) do
    response = ip
               |> Huex.connect()
               |> Huex.authorize(devicetype)

    case response.status do
      :error -> {:error, response.error["description"]}
      _ -> {:ok, response.username}
    end
  end
end