defmodule Huey.SceneServer do

  @name :scene_server

  use GenServer

  alias Huey.{Bridge, Light, LightUpdater}

  # Client API

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def activate(scene_name) do
    GenServer.call(@name, {:activate, scene_name})
  end

  def create(scene) do
    GenServer.call(@name, {:create, scene})
  end

  # Callbacks

  def init(_state) do
    state = %{blue_jays: [
      %Light{number: 1, color: %{h: 240, s: 254, b: 254}},
      %Light{number: 3, color: %{h:   0, s: 254, b: 150}},
      %Light{number: 4, color: %{h: 260, s: 254, b: 150}},
      %Light{number: 5, color: %{h: 240, s: 254, b: 254}}
    ]}
    {:ok, state}
  end

  def handle_call({:activate, scene_name}, _from, state) do
    lights = state[scene_name]
    Enum.each(lights, fn(light) -> update_light(light) end)
    {:reply, :ok, state}
  end

  def handle_call({:create, scene}, _from, state) do
    new_state = Map.merge(state, scene)
    {:reply, :ok, new_state}
  end

  defp update_light(light) do
    %Light{light | connection: connection()}
    |> LightUpdater.set_color(light.color)
  end

  defp connection do
    {:ok, bridge} = Bridge.connect("192.168.0.111", "FJtuwhryNZLot-HGCdn0KkV3A-T0m9ad1OmT-512")
#    {:ok, bridge} = Bridge.connect("192.168.0.25", "nWLG30rEJAPxEgfffu3FMezYhfGtc7xbayy6mIyP")
    %Huey.Connection{bridge: bridge}
  end
end