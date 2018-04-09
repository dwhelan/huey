defmodule Huey.Light do
  def turn_on({:ok, bridge}, light_number) do
    Huex.turn_on(bridge, light_number)
    |> handle_response
  end

  def turn_off({:ok, bridge}, light_number) do
    Huex.turn_off(bridge, light_number)
    |> handle_response
  end

  defp handle_response(response) do
    case response.status do
      :error -> {:error, response.error["description"]}
      _ -> {:ok, response}
    end
  end

end
