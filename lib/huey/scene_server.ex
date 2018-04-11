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


  # Callbacks
  def init(_state) do
    light_state = [
      %LightState{number: 1, color: {240, 254, 254}},
      %LightState{number: 3, color: {  0, 254, 150}},
      %LightState{number: 4, color: {260, 254, 150}},
      %LightState{number: 5, color: {240, 254, 254}}
    ]
    state = %Scene{name: "blue_jays", light_states: light_state}
    {:ok, state}
  end

  def handle_call({:activate, _scene_name}, _from, state) do
    Enum.each(state.light_states, fn (light_state) -> update_light(light_state) end)
    {:reply, :ok, state}
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