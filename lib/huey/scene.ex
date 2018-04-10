defmodule Huey.LightState do
  defstruct [number: 0, color: nil, brightness: 1.0, on: true]
end

defmodule Huey.Scene do
  defstruct [name: "", light_states: []]
end

# Create scene
# POST http://host/scene/blue_jays - create a scene
#   {} post contains json => Elixir data structure
#   http server -
#
# Activate scene
# POST http://host/scene/blue_jays/activate - activates a scene
#
# GET  http://host/scene/blue_jays - retrieve a scene
