defmodule Huey.SceneServer do

  @name :scene_server

  use GenServer

  alias Huey.{Bridge, Light, LightState, Scene}

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def activate(scene_name) do
    GenServer.call(@name, {:activate, scene_name})
  end

  def create(scene) do
    GenServer.cast(@name, {:create, scene})
  end

#  defstruct [number: 0, color: nil, brightness: 1.0, on: true]
#
#  defmodule Huey.Scene do
#  defstruct [name: "", light_states: []]


  # Callbacks
  def init(_state) do
    light_state = [
      %LightState{number: 1, color: {240, 254, 254}},
      %LightState{number: 3, color: {0, 254, 254}},
      %LightState{number: 4, color: {252, 254, 200}},
      %LightState{number: 5, color: {240, 254, 254}}
    ]
    state = %Scene{name: "blue_jays", light_states: light_state}
    {:ok, state}
  end

  def handle_call({:activate, _scene_name}, _from, state) do
    bridge = bridge()
    Enum.each()
    {:ok, response} = Light.set_color(bridge, 4, {252, 254, 200})
    {:reply, response, state}
  end

  def handle_cast({:create, _scene}, _from, state) do
    # do what we need to do
    {:noreply, state}
  end

  defp bridge do
    {:ok, bridge} = Bridge.connect("192.168.0.111", "FJtuwhryNZLot-HGCdn0KkV3A-T0m9ad1OmT-512")
    bridge
  end

end