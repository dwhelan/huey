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
    body = conn.body_params
    {:ok, json_string} = Poison.encode(body)
    IO.inspect json_string
    {:ok, scene} = Poison.decode(json_string, as: :atoms!)
    IO.inspect scene
    response = Huey.SceneServer.create(scene)
    send_resp(conn, 200, "thanks")
  end
end
