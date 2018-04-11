defmodule Huey.SceneServerTest do
  use ExUnit.Case, asnyc: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney, clear_mock: true

  alias Huey.{SceneServer, LightState}

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures")
    HTTPoison.start()
  end

  setup do
    light_states = [
      %LightState{number: 1, color: {240, 254, 254}},
      %LightState{number: 3, color: {0, 254, 150}},
      %LightState{number: 4, color: {260, 254, 150}},
      %LightState{number: 5, color: {240, 254, 254}}
    ]
    state = %{"blue_jays" => light_states}

    [state: state]
  end

  test "can apply a scene to a set of lights", context do
    use_cassette("activate_scene") do
      result = SceneServer.handle_call({:activate, "blue_jays"}, [], context[:state])
      assert {:reply, :ok, context[:state]} == result
    end
  end

  test "can create a new scene", context do
    light_states = [
      %LightState{number: 1, color: {0, 254, 150}},
      %LightState{number: 3, color: {0, 0, 254}},
      %LightState{number: 4, color: {0, 0, 254}},
      %LightState{number: 5, color: {0, 254, 150}}
    ]
    new_scene = %{"oh_canada" => light_states}
    {_, _, updated_state} = SceneServer.handle_call({:create, new_scene}, [], context[:state])
    assert updated_state["oh_canada"] == light_states
  end
end