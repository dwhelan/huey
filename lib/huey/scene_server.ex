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
  def init(state) do
    light_state = [
    %LightState{}
    ]

    {:ok, state}
  end

  def handle_call({:activate, scene_name}, _from, state) do
    {:ok, bridge} = Bridge.connect("192.168.0.111", "FJtuwhryNZLot-HGCdn0KkV3A-T0m9ad1OmT-512")
    Light.set_color(bridge, 3, {225, 254, 254})

    {:reply, :ok, state}
  end

  def handle_cast({:create, scene}, _from, state) do
    # do what we need to do
    {:noreply, state}
  end

end