defmodule Huey.SceneServer do

  @name :scene_server

  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def activate(scene_name) do
    GenServer.call(@name, {:activate, scene_name})
  end

  def create(scene) do
    GenServer.cast(@name, {:create, scene})
  end

  # Callbacks
  def init(state) do
    {:ok, state}
  end

  def handle_call({:activate, scene_name}, _from, state) do
    # Do my work
    IO.puts "I am activated!!!"
    {:reply, :ok, state}
  end

  def handle_cast({:create, scene}, _from, state) do
    # do what we need to do
    {:noreply, state}
  end

end