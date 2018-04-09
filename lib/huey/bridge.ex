defmodule Huey.Bridge do
  def authorize(ip, devicetype) do
    response = ip
    |> Huex.connect()
    |> Huex.authorize(devicetype)

    if response.status == :error do
      {:error, response.error.description}
    else
      {:ok, response.username}
    end
  end
end