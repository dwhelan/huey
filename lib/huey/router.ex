defmodule Huey.Router do
  use Plug.Router
  require Logger

  plug Plug.Logger

#  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :match
  plug :dispatch

  def init(options) do
    options
  end

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http(__MODULE__, [])
  end

  get "/activatescene/:scene" do
    Huey.SceneServer.activate(String.to_atom(scene))
    send_resp(conn, 200, "lights updated")
  end

  post "/createscene" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    {:ok, scene} = Poison.decode(body, keys: :atoms)
    Huey.SceneServer.create(scene)
    send_resp(conn, 201, "thanks eh?")
  end
end
