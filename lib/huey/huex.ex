defmodule Huey.Huex do
  alias Huex.Bridge

  def handle_response(%Bridge{status: :error} = response, _data) do
    {:error, response.error["description"]}
  end

  def handle_response(%Bridge{status: :ok}, data) do
    {:ok, data}
  end
end
