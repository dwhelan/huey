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
    response = Huey.SceneServer.activate(String.to_atom(scene))
    send_resp(conn, 200, "lights updated")
  end

  post "/createscene" do
    {:ok, json_string} = Poison.encode(conn.body_params)
    {:ok, scene} = Poison.decode(json_string, keys: :atoms)
    response = Huey.SceneServer.create(scene)
    send_resp(conn, 201, "thanks eh?")
  end
end
