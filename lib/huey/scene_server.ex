defmodule Huey.SceneServer do

  @name :scene_server

  use GenServer

  alias Huey.{Bridge, Light, LightState}

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
    light_states = [
      %LightState{number: 1, color: {240, 254, 254}},
      %LightState{number: 3, color: {  0, 254, 150}},
      %LightState{number: 4, color: {260, 254, 150}},
      %LightState{number: 5, color: {240, 254, 254}}
    ]
    state = %{"blue_jays" => light_states}
    {:ok, state}
  end

  def handle_call({:activate, scene_name}, _from, state) do
    light_states = state[scene_name]
    Enum.each(light_states, fn (light_state) -> update_light(light_state) end)
    {:reply, :ok, state}
  end

  def handle_call({:create, scene}, _from, state) do
    new_state = Map.merge(state, scene)
    {:reply, :ok, new_state}
  end

  defp bridge do
    {:ok, bridge} = Bridge.connect("192.168.0.111", "FJtuwhryNZLot-HGCdn0KkV3A-T0m9ad1OmT-512")
    bridge
  end

  defp update_light(light_state) do
    Light.create(bridge(), light_state.number)
    |> Light.set_color(light_state.color)
  end
end