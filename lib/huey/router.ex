defmodule Huey.Router do
  use Plug.Router
  require Logger

  plug Plug.Logger

  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :match
  plug :dispatch

  def init(options) do
    options
  end

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http(__MODULE__, [])
  end

  get "/activatescene/:scene" do
    response = Huey.SceneServer.activate(scene)
    send_resp(conn, 200, "lights updated")
  end

  post "/createscene" do
    IO.inspect conn
    IO.inspect conn.body_params
    {status, body} =
      case conn.body_params do
        %{"name" => name} -> {200, say_hello(name)}
        _ -> {422, missing_name()}
      end
    send_resp(conn, status, body)
  end

  defp say_hello(name) do
    Poison.encode!(%{response: "Hello, #{name}!"})
  end

  defp missing_name do
    Poison.encode!(%{error: "Expected a \"name\" key"})
  end
end
